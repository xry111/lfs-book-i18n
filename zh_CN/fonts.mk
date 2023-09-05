WGET = wget --retry-on-http-error=503

font1 = fonts/NotoSansCJKsc-Regular.otf
font2 = fonts/NotoSansCJKsc-Bold.otf
font3 = fonts/NotoSerifCJKsc-Regular.otf
font4 = fonts/NotoSerifCJKsc-Bold.otf
font5 = fonts/SourceHanMonoSC-Regular.otf
font6 = fonts/SourceHanMonoSC-Bold.otf

pdf: $(font1) $(font2) $(font3) $(font4) $(font5) $(font6)

$(font1) $(font2): noto-cjk-commit
	mkdir -pv fonts
	grep $@'$$' fonts.md5 | md5sum -c || \
	$(WGET) https://github.com/notofonts/noto-cjk/raw/$$(cat $<)/Sans/OTF/SimplifiedChinese/$(@F) -O $@

$(font3) $(font4): noto-cjk-commit
	mkdir -pv fonts
	grep $@'$$' fonts.md5 | md5sum -c || \
	$(WGET) https://github.com/notofonts/noto-cjk/raw/$$(cat $<)/Serif/OTF/SimplifiedChinese/$(@F) -O $@

$(font5): source-han-mono-commit
	mkdir -pv fonts
	grep $@'$$' fonts.md5 | md5sum -c || \
	$(WGET) https://github.com/adobe-fonts/source-han-mono/raw/$$(cat $<)/Regular/OTC/$(@F) -O $@

$(font6): source-han-mono-commit
	mkdir -pv fonts
	grep $@'$$' fonts.md5 | md5sum -c || \
	$(WGET) https://github.com/adobe-fonts/source-han-mono/raw/$$(cat $<)/Bold/OTC/$(@F) -O $@
