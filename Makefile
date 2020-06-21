SHELL := /bin/bash
default: html

LFS_EN = /home/xry111/svn-repos/LFS-BOOK
MLANG=zh_CN
ALL_XML_FILES = $(shell find $(LFS_EN) -type f -name '*.xml')
EXCLUDE_FILES = $(LFS_EN)/chapter01/livecd.xml \
				$(LFS_EN)/chapter04/creatingtoolsdir.xml \
				$(LFS_EN)/chapter04/aboutlfs.xml \
				$(LFS_EN)/chapter08/adjusting.xml
XML_FILES = $(filter-out $(EXCLUDE_FILES), $(ALL_XML_FILES))
PO_FILES = $(patsubst $(LFS_EN)/%.xml, $(MLANG)/%.po, $(XML_FILES))

$(MLANG)/chapter01/changelog.po: $(LFS_EN)/chapter01/changelog.xml changelogtranslator.py templatetranslator.py
	mkdir -pv "$(@D)"
	po4a-updatepo -f docbook -m $< -p $@
	./changelogtranslator.py $(MLANG)

$(MLANG)/%.po: $(LFS_EN)/%.xml
	mkdir -pv "$(@D)"
	po4a-updatepo -f docbook -m $< -p $@
	touch $@

MXML_FILES = $(patsubst $(LFS_EN)/%.xml, %.xml, $(XML_FILES))
BOOK_FILES = $(patsubst $(LFS_EN)/%, %, $(shell find $(LFS_EN) -type f -not -path "$(LFS_EN)/.svn/*" -not -path "$(LFS_EN)/render/*"))
KEEP_FILES = $(filter-out $(MXML_FILES), KEEP_FILES)

MBOOK_FILES = $(patsubst %, $(MLANG)/book/%, $(BOOK_FILES))

.PHONY: html booksrc nochunks pdf

html: booksrc
	rm -rf $(MLANG)/book/render # without this tidy may be stupidly slow
	make -C $(MLANG)/book REV=$(REV) BASEDIR=render

nochunks: booksrc
	rm -rf $(MLANG)/book/nochunks
	make -C $(MLANG)/book REV=$(REV) BASEDIR=nochunks nochunks

pdf: booksrc
	rm -rf $(MLANG)/book/pdf
	make -C $(MLANG)/book REV=$(REV) BASEDIR=pdf pdf

booksrc: $(MBOOK_FILES) $(PATCHES)
	[ ! -e $(MLANG)/fix.sh ] || (pushd $(MLANG)/book; sh ../fix.sh; popd)

$(MLANG)/book/%.xml: $(LFS_EN)/%.xml $(MLANG)/%.po
	mkdir -pv "$(@D)"
	po4a-translate -f docbook -m $< -p $(filter-out $<, $^) -l $@
	[ -e $@ ] || cp -v $< $@

$(MLANG)/book/%: $(LFS_EN)/%
	mkdir -pv "$(@D)"
	cp -v $< $@
