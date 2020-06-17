LFS_EN = /home/xry111/svn-repos/LFS-BOOK
MLANG=zh_CN
ALL_XML_FILES = $(shell find $(LFS_EN) -type f -name '*.xml')
EXCLUDE_FILES = $(LFS_EN)/chapter01/changelog.xml \
				$(LFS_EN)/chapter01/livecd.xml
XML_FILES = $(filter-out $(EXCLUDE_FILES), $(ALL_XML_FILES))
PO_FILES = $(patsubst $(LFS_EN)/%.xml, $(MLANG)/%.po, $(XML_FILES))

run: $(PO_FILES)

$(MLANG)/%.po: $(LFS_EN)/%.xml
	mkdir -pv "$(@D)"
	po4a-updatepo -f docbook -m $< -p $@

MXML_FILES = $(patsubst $(LFS_EN)/%.xml, %.xml, $(XML_FILES))
BOOK_FILES = $(patsubst $(LFS_EN)/%, %, $(shell find $(LFS_EN) -type f -not -path "$(LFS_EN)/.svn/*"))
KEEP_FILES = $(filter-out $(MXML_FILES), KEEP_FILES)

MBOOK_FILES = $(patsubst %, $(MLANG)/book/%, $(BOOK_FILES))

booksrc: $(MBOOK_FILES)

$(MLANG)/book/%.xml: $(LFS_EN)/%.xml $(MLANG)/%.po
	mkdir -pv "$(@D)"
	po4a-translate -f docbook -m $< -p $(filter-out $<, $^) -l $@
	[ -e $@ ] || cp -v $< $@

$(MLANG)/book/%: $(LFS_EN)/%
	mkdir -pv "$(@D)"
	cp -v $< $@

test:
	echo $(XML_FILES)
