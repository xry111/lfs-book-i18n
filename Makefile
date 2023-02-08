LANG=en_US.UTF-8

SHELL := /bin/bash
default: html

LFS_EN = lfs-en
MLANG = zh_CN

include $(MLANG)/lang.mk

CMD_FIND_XML = find $(LFS_EN) -type f -name '*.xml' \
               ! \( -name 'lfs-l10n.xml' -or -name 'changelog.xml' \)
XML_FILES = $(shell $(CMD_FIND_XML))
POT_DIRS = $(sort $(patsubst $(LFS_EN)/%, pot/%, $(dir $(XML_FILES))))
PO_FILES = $(patsubst $(LFS_EN)/%.xml, $(MLANG)/%.po, $(XML_FILES))
MKPO4ACFG = ./mkpo4acfg.py $(MLANG)

$(MLANG)/book: ; mkdir -pv $@

-include local.mk

$(PO_FILES) &: $(XML_FILES) mkpo4acfg.py
	mkdir -pv $(POT_DIRS)
	$(CMD_FIND_XML) | $(MKPO4ACFG) > po4a.cfg
	po4a --no-translations po4a.cfg

$(MLANG)/chapter01/changelog.po: lfs-en/chapter01/changelog.xml \
                                 changelogtranslator.py         \
                                 templatetranslator.py
	mkdir -pv pot/chapter01
	echo lfs-en/chapter01/changelog.xml | $(MKPO4ACFG) > po4a-changelog.cfg
	po4a --no-translations po4a-changelog.cfg
	./changelogtranslator.py $(MLANG)
	# Run again. polib does not agree with po4a on line wrappings
	# in the .po file, so we need to settle it down.
	po4a --no-translations --force po4a-changelog.cfg

MXML_FILES = $(patsubst $(LFS_EN)/%.xml, $(MLANG)/book/%.xml, $(XML_FILES))
BOOK_FILES = $(patsubst $(LFS_EN)/%, %, $(shell find $(LFS_EN) -type f -not -path "$(LFS_EN)/.git"))
MBOOK_FILES = $(patsubst %, $(MLANG)/book/%, $(BOOK_FILES))

.PHONY: html booksrc nochunks pdf pofiles

pofiles: $(PO_FILES) $(MLANG)/chapter01/changelog.po

html: booksrc
	rm -rf $(MLANG)/book/render # without this tidy may be stupidly slow
	tmpdir=$$(mktemp -d); \
	make -j1 -C $(MLANG)/book REV=$(REV) BASEDIR=render RENDERTMP=$$tmpdir; \
	rm -rf $$tmpdir

nochunks: booksrc
	rm -rf $(MLANG)/book/nochunks
	tmpdir=$$(mktemp -d); \
	make -j1 -C $(MLANG)/book REV=$(REV) BASEDIR=nochunks RENDERTMP=$$tmpdir nochunks; \
	rm -rf $$tmpdir

pdf: booksrc
	rm -rf $(MLANG)/book/pdf
	tmpdir=$$(mktemp -d); \
	make -j1 -C $(MLANG)/book REV=$(REV) BASEDIR=pdf RENDERTMP=$$tmpdir pdf; \
	rm -rf $$tmpdir

booksrc: $(MBOOK_FILES) $(ORIG_FILES) $(MLANG)/book/version.ent
	[ ! -e $(MLANG)/fix.sh ] || (pushd $(MLANG)/book; sh ../fix.sh; popd)

$(MLANG)/book/tidy.conf: lfs-en/tidy.conf $(MLANG)/lang.mk
	sed -e '/output-encoding:/s|latin1|$(M_ENCODING_ALT)|' $< > $@

# $(MLANG)/book is not a git repo, so we need to generate the version info
# now and silence git-version.sh.  lang.mk SHALL contain the recipe for
# git-version-l10n.sh.
.PHONY: version
version: $(MLANG)/book/git-version-l10n.sh
	cd $(<D); \
	REV=$(REV) GIT_DIR=$(PWD)/lfs-en/.git ./git-version-l10n.sh $(REV)

$(MLANG)/book/version.ent $(MLANG)/book/conditional.ent: version; true

$(MLANG)/book/git-version.sh:
	echo '#!/bin/sh' > $@; echo 'exit 0' >> $@; chmod -v 755 $@

$(MXML_FILES) &: $(XML_FILES) $(PO_FILES) mkpo4acfg.py
	mkdir -pv $(POT_DIRS)
	$(CMD_FIND_XML) | $(MKPO4ACFG) > po4a.cfg
	po4a po4a.cfg
	sed -e 's|<book>|<book lang="$(M_DOCBOOK_LANG)">|' -i $(MLANG)/book/index.xml
	# This should be handled by po4a, but if some pages are not done yet
	# we will need to do it manually.
	sed -e '/encoding=/s|ISO-8859-1|$(M_ENCODING)|' -i $@
	cd $(MLANG)/book; $(PWD)/po4a_issue295.sh

L10N_XML = stylesheets/lfs-xsl/lfs-l10n.xml

$(MLANG)/book/$(L10N_XML): lfs-en/$(L10N_XML)
	sed -e '/encoding=/s|ISO-8859-1|$(M_ENCODING)|' $< > $@

$(MLANG)/book/chapter01/changelog.xml: $(LFS_EN)/chapter01/changelog.xml \
                                       $(MLANG)/chapter01/changelog.po
	mkdir -pv pot/chapter01
	echo lfs-en/chapter01/changelog.xml | $(MKPO4ACFG) > po4a-changelog.cfg
	po4a po4a-changelog.cfg
	sed -e '/encoding=/s|ISO-8859-1|$(M_ENCODING)|' -i $@

$(MLANG)/book/%: $(LFS_EN)/%
	mkdir -pv "$(@D)"
	cp -v $< $@

# The following targets are used for checking any unintentionally command
# changes.

KNOWN_DIFF = chapter09/*-symlinks \
             chapter09/*-network  \
             chapter09/*-profile  \
             chapter09/*-console  \
             chapter09/*-locale   \
             chapter10/*-fstab

cmd/en/sysv/stamp: $(XML_FILES)
	make -C lfs-en DUMPDIR="$(PWD)/$(@D)" REV=sysv dump-commands
	cd $(@D); rm -f $(KNOWN_DIFF)
	touch $@

cmd/en/systemd/stamp: $(XML_FILES)
	make -C lfs-en DUMPDIR="$(PWD)/$(@D)" REV=systemd dump-commands
	cd $(@D); rm -f $(KNOWN_DIFF)
	touch $@

cmd/$(MLANG)/sysv/stamp: $(MXML_FILES)
	make -C $(MLANG)/book DUMPDIR="$(PWD)/$(@D)" REV=sysv dump-commands
	cd $(@D); rm -f $(KNOWN_DIFF)
	touch $@

cmd/$(MLANG)/systemd/stamp: $(MXML_FILES)
	make -C $(MLANG)/book DUMPDIR="$(PWD)/$(@D)" REV=systemd dump-commands
	cd $(@D); rm -f $(KNOWN_DIFF)
	touch $@

.PHONY: check-cmd check-cmd-sysv check-cmd-systemd

check-cmd-sysv: cmd/en/sysv/stamp cmd/$(MLANG)/sysv/stamp
	diff $(^D) -Naur

check-cmd-systemd: cmd/en/systemd/stamp cmd/$(MLANG)/systemd/stamp
	diff $(^D) -Naur

check-cmd: check-cmd-sysv check-cmd-systemd
