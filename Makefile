LFS_EN = /home/xry111/svn-repos/LFS-BOOK
MLANG=zh_CN
ALL_XML_FILES = $(shell find $(LFS_EN) -type f -name '*.xml')
EXCLUDE_FILES = $(LFS_EN)/chapter01/livecd.xml
XML_FILES = $(filter-out $(EXCLUDE_FILES), $(ALL_XML_FILES))
PO_FILES = $(patsubst $(LFS_EN)/%.xml, $(MLANG)/%.po, $(XML_FILES))

run: $(PO_FILES)

$(MLANG)/chapter01/changelog.po: $(LFS_EN)/chapter01/changelog.xml changelogtranslator.py templatetranslator.py
	mkdir -pv "$(@D)"
	po4a-updatepo -f docbook -m $< -p $@
	./changelogtranslator.py $(MLANG)

$(MLANG)/%.po: $(LFS_EN)/%.xml
	mkdir -pv "$(@D)"
	po4a-updatepo -f docbook -m $< -p $@

MXML_FILES = $(patsubst $(LFS_EN)/%.xml, %.xml, $(XML_FILES))
BOOK_FILES = $(patsubst $(LFS_EN)/%, %, $(shell find $(LFS_EN) -type f -not -path "$(LFS_EN)/.svn/*"))
KEEP_FILES = $(filter-out $(MXML_FILES), KEEP_FILES)

MBOOK_FILES = $(patsubst %, $(MLANG)/book/%, $(BOOK_FILES))

booksrc: $(MBOOK_FILES) $(PATCHES)

$(MLANG)/book/%.xml: $(LFS_EN)/%.xml $(MLANG)/%.po
	mkdir -pv "$(@D)"
	po4a-translate -f docbook -m $< -p $(filter-out $<, $^) -l $@
	[ -e $@ ] || cp -v $< $@
	relpath=$$(echo $@ | sed 's@$(MLANG)/book/@@'); \
	patch_path=$(MLANG)/patches/$${relpath}.patch; \
	if [ -e $${patch_path} ]; then \
		pushd $(MLANG)/book; patch -Np1 -i ../patches/$${relpath}.patch; popd; \
	fi

$(MLANG)/book/%: $(LFS_EN)/%
	mkdir -pv "$(@D)"
	cp -v $< $@
	relpath=$$(echo $@ | sed 's@$(MLANG)/book/@@'); \
	patch_path=$(MLANG)/patches/$${relpath}.patch; \
	if [ -e $${patch_path} ]; then \
		pushd $(MLANG)/book; patch -Np1 -i ../patches/$${relpath}.patch; popd; \
	fi

test:
	echo $(XML_FILES)
