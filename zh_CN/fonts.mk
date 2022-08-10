font1 = fonts/NotoSansCJKsc-Regular.otf
font2 = fonts/NotoSansCJKsc-Bold.otf
font3 = fonts/NotoSerifCJKsc-Regular.otf
font4 = fonts/NotoSerifCJKsc-Bold.otf
font5 = fonts/SourceHanMonoSC-Regular.otf
font6 = fonts/SourceHanMonoSC-Bold.otf

pdf: $(font1) $(font2) $(font3) $(font4) $(font5) $(font6)

$(font1) $(font2): noto-cjk-commit
	mkdir -pv fonts
	wget https://github.com/googlefonts/noto-cjk/raw/$$(cat noto-cjk-commit)/Sans/OTF/SimplifiedChinese/$$(basename $@) -O $@

$(font3) $(font4): noto-cjk-commit
	mkdir -pv fonts
	wget https://github.com/googlefonts/noto-cjk/raw/$$(cat noto-cjk-commit)/Serif/OTF/SimplifiedChinese/$$(basename $@) -O $@

$(font5): source-han-mono-commit
	mkdir -pv fonts
	wget https://github.com/adobe-fonts/source-han-mono/raw/$$(cat $<)/Regular/OTC/$$(basename $@) -O $@

$(font6): source-han-mono-commit
	mkdir -pv fonts
	wget https://github.com/adobe-fonts/source-han-mono/raw/$$(cat $<)/Bold/OTC/$$(basename $@) -O $@
