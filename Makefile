SHELL := /bin/bash
default: html

LFS_EN = lfs-en
MLANG = zh_CN
CMD_FIND_XML = find $(LFS_EN) -type f -name '*.xml' ! -name 'lfs-l10n.xml'
XML_FILES = $(shell $(CMD_FIND_XML))
POT_DIRS = $(sort $(patsubst $(LFS_EN)/%, pot/%, $(dir $(XML_FILES))))
PO_FILES = $(patsubst $(LFS_EN)/%.xml, $(MLANG)/%.po, $(XML_FILES))

-include local.mk

$(PO_FILES) &: $(XML_FILES) mkpo4acfg.py changelogtranslator.py
	mkdir -pv $(POT_DIRS)
	$(CMD_FIND_XML) | ./mkpo4acfg.py > po4a.cfg
	po4a --no-translations po4a.cfg
	./changelogtranslator.py $(MLANG)

MXML_FILES = $(patsubst $(LFS_EN)/%.xml, $(MLANG)/book/%.xml, $(XML_FILES))
BOOK_FILES = $(patsubst $(LFS_EN)/%, %, $(shell find $(LFS_EN) -type f -not -path "$(LFS_EN)/.git"))
MBOOK_FILES = $(patsubst %, $(MLANG)/book/%, $(BOOK_FILES))

.PHONY: html booksrc nochunks pdf pofiles

pofiles: $(PO_FILES)

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

ORIG_FILES = $(MLANG)/book/general.ent.orig \
			 $(MLANG)/book/Makefile.orig    \
			 $(MLANG)/book/git-version.sh.orig

booksrc: $(MBOOK_FILES) $(ORIG_FILES)
	[ ! -e $(MLANG)/fix.sh ] || (pushd $(MLANG)/book; sh ../fix.sh; popd)

$(MXML_FILES) &: $(XML_FILES) $(PO_FILES) mkpo4acfg.py
	mkdir -pv $(POT_DIRS)
	$(CMD_FIND_XML) | ./mkpo4acfg.py > po4a.cfg
	po4a po4a.cfg

$(MLANG)/book/%: $(LFS_EN)/%
	mkdir -pv "$(@D)"
	cp -v $< $@

$(MLANG)/book/general.ent.orig: $(LFS_EN)/general.ent
	mkdir -pv "$(@D)"
	cp -v $< $@

$(MLANG)/book/Makefile.orig: $(LFS_EN)/Makefile
	mkdir -pv "$(@D)"
	cp -v $< $@

$(MLANG)/book/git-version.sh.orig: $(LFS_EN)/git-version.sh
	mkdir -pv "$(@D)"
	cp -v $< $@
	sed -e "2i export GIT_DIR=$(PWD)/lfs-en/.git" \
	    -e "s/\[ .*trunk.* \]/true/"                \
	    -i $@
