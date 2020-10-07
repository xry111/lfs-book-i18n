SHELL := /bin/bash
default: html

LFS_EN = $(HOME)/svn-repos/LFS-BOOK
MLANG=zh_CN
ALL_XML_FILES = $(shell find $(LFS_EN) -type f -name '*.xml')
EXCLUDE_FILES = # empty for now
XML_FILES = $(filter-out $(EXCLUDE_FILES), $(ALL_XML_FILES))
PO_FILES = $(patsubst $(LFS_EN)/%.xml, $(MLANG)/%.po, $(XML_FILES))
PO4A_FLAGS = -f docbook --porefs none

ifneq (,$(wildcard ./local.mk))
include local.mk
endif

$(MLANG)/chapter01/changelog.po: $(LFS_EN)/chapter01/changelog.xml changelogtranslator.py templatetranslator.py
	mkdir -pv "$(@D)"
	po4a-updatepo $(PO4A_FLAGS) -m $< -p $@
	./changelogtranslator.py $(MLANG)

$(MLANG)/%.po: $(LFS_EN)/%.xml
	mkdir -pv "$(@D)"
	po4a-updatepo $(PO4A_FLAGS) -m $< -p $@
	touch $@

MXML_FILES = $(patsubst $(LFS_EN)/%.xml, %.xml, $(XML_FILES))
BOOK_FILES = $(patsubst $(LFS_EN)/%, %, $(shell find $(LFS_EN) -type f -not -path "$(LFS_EN)/.svn/*" -not -path "$(LFS_EN)/render/*"))
KEEP_FILES = $(filter-out $(MXML_FILES), KEEP_FILES)

MBOOK_FILES = $(patsubst %, $(MLANG)/book/%, $(BOOK_FILES))

.PHONY: html booksrc nochunks pdf pofiles

pofiles: $(PO_FILES)

html: booksrc
	rm -rf $(MLANG)/book/render # without this tidy may be stupidly slow
	make -C $(MLANG)/book REV=$(REV) BASEDIR=render

nochunks: booksrc
	rm -rf $(MLANG)/book/nochunks
	make -C $(MLANG)/book REV=$(REV) BASEDIR=nochunks nochunks

pdf: booksrc
	rm -rf $(MLANG)/book/pdf
	pushd $(MLANG)/book; sh ../fetch_fonts.sh; popd
	make -C $(MLANG)/book REV=$(REV) BASEDIR=pdf pdf

ORIG_FILES = $(MLANG)/book/general.ent.orig \
			 $(MLANG)/book/Makefile.orig

booksrc: $(MBOOK_FILES) $(PATCHES) $(ORIG_FILES)
	[ ! -e $(MLANG)/fix.sh ] || (pushd $(MLANG)/book; sh ../fix.sh; popd)

$(MLANG)/book/%.xml: $(LFS_EN)/%.xml $(MLANG)/%.po
	mkdir -pv "$(@D)"
	po4a-translate -f docbook -m $< -p $(filter-out $<, $^) -l $@
	[ -e $@ ] || cp -v $< $@

$(MLANG)/book/%: $(LFS_EN)/%
	mkdir -pv "$(@D)"
	cp -v $< $@

$(MLANG)/book/general.ent.orig: $(LFS_EN)/general.ent
	mkdir -pv "$(@D)"
	cp -v $< $@

$(MLANG)/book/Makefile.orig: $(LFS_EN)/Makefile
	mkdir -pv "$(@D)"
	cp -v $< $@

