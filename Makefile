LFS_EN = /home/xry111/svn-repos/LFS-BOOK
MLANG=zh_CN
XML_FILES = $(shell find $(LFS_EN) -type f -name '*.xml')
PO_FILES = $(patsubst $(LFS_EN)/%.xml, $(MLANG)/%.po, $(XML_FILES))

test:
	echo $(PO_FILES)

run: $(PO_FILES)

$(MLANG)/%.po: $(LFS_EN)/%.xml
	mkdir -pv "$(@D)"
	po4a-updatepo -f docbook -m $< -p $@
