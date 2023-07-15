M_ENCODING = UTF-8
M_ENCODING_ALT = utf8
M_DOCBOOK_LANG = zh_cn

THIS = zh_CN/lang.mk

zh_CN/book/general.ent: $(LFS_EN)/general.ent $(THIS)
	mkdir -pv $(@D)
	reldate=$$(grep '% reldate' $< |                               \
	           sed 's/.*"\(.*\)".*/\1/;s/\(st\|nd\|rd\|th\),/,/'); \
	reldate_cn=$$(date -d "$$reldate" "+%Y 年 %m 月 %d 日"         \
	              2>/dev/null | sed 's@ 0@ @g');                   \
	sed -e 's/Approximate build time/估计构建时间/'                \
	    -e 's/Required disk space/需要硬盘空间/'                   \
	    -e 's/Installation depends on/安装依赖于/'                 \
	    -e 's/Required at runtime/运行时依赖于/'                   \
	    -e 's/Test suite depends on/测试依赖于/'                   \
	    -e 's/Must be installed before/必须在下列软件包之前安装/'  \
	    -e 's/Optional dependencies/可选依赖项/'                   \
	    -e "/% reldate/s/\".*\"/\"$${reldate_cn}\"/"               \
	    -e "s/Update the auxilary .*/更新构建系统使用的辅助脚本，/"        \
		-e "s/building.*for LoongArch:/以允许为 LoongArch 构建该软件包：/" \
	    $< > $@

zh_CN/book/packages.ent: $(LFS_EN)/packages.ent $(THIS)
	mkdir -pv $(@D)
	sed -e 's/less than/不到/'                              \
	    -e 's/typically about/一般约/'                      \
	    -e 's/about \(.*\) with tests/计入测试时间为约 \1/' \
	    -e 's/with tests/已计入测试时间/'                   \
	    -e '/encoding=/s/ISO-8859-1/UTF-8/'                 \
	    -e 's/\([0-9.]* SBU\) on a spinning disk, \(.* SBU\) on an SSD/机械硬盘上 \1，固态硬盘上 \2/' \
	    $< > $@

zh_CN/book/git-version-l10n.sh: $(LFS_EN)/git-version.sh $(THIS)
	mkdir -pv $(@D)
	sed -e '/full_date=/ i month_zh_cn=$$(date -d "$$commit_date" "+%m" | sed "s/^0//")' \
	    -e '/full_date=/ s@".*"@"$$year 年 $$month_zh_cn 月 $$day 日"@' \
	    $< > $@
	chmod -v 755 $@

COPY_FILES = zh_CN/book/fonts.mk        \
             zh_CN/book/fop.xml         \
             zh_CN/book/noto-cjk-commit \
             zh_CN/book/source-han-mono-commit

zh_CN/book/Makefile: $(LFS_EN)/Makefile $(THIS) $(COPY_FILES) $(@D)
	mkdir -pv $(@D)
	sed -e '/xa9/d' \
	    -e 's|fop -q|& -c fop.xml|' \
	    -e '/fop -q/i \\trm -rfv $$(RENDERTMP)/fonts; ln -sv $$(CURDIR)/fonts $$(RENDERTMP)/fonts' \
	    $< > $@
	echo 'include fonts.mk' >> $@


$(COPY_FILES): zh_CN/$(@F)
	mkdir -pv $(@D)
	cp zh_CN/$(@F) $(@D)

FONTS_XSL = zh_CN/book/stylesheets/lfs-xsl/pdf/zh_CN-fonts.xsl
PDF_XSL = stylesheets/lfs-xsl/pdf.xsl

$(FONTS_XSL): zh_CN/zh_CN-fonts.xsl
	mkdir -pv $(@D)
	cp $< $@

zh_CN/book/$(PDF_XSL): $(LFS_EN)/$(PDF_XSL) $(FONTS_XSL) $(THIS)
	mkdir -pv $(@D)
	sed '/<\/xsl:stylesheet>/i <xsl:include href="pdf/zh_CN-fonts.xsl"/>' \
		< $< > $@
