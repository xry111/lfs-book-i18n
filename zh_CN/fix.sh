#!/bin/sh

# fix some English and ASCII specific stuff which can not be handled by po4a

# This should be handled by po4a, but if some pages are not done yet
# we will need to do it manually.
sed -e '/encoding=/s|ISO-8859-1|UTF-8|' -i $(find -name \*.xml)

# Let tidy output UTF-8
sed -e '/output-encoding:/s|latin1|utf8|' -i tidy.conf

sed -e 's|<book>|<book lang="zh_cn">|' -i index.xml

sed -e '/xreflabel/s|Chapter.nbsp.1 - Mailing Lists|第 1 章 - 邮件列表|' \
	-e '/xreflabel/s|Chapter.nbsp.1 - Mirror sites|第 1 章 - 镜像站|'    \
	-i chapter01/resources.xml

sed -e '/xreflabel/s|Chapter.nbsp.\([0-9]\+\)|第 \1 章|' \
	-i chapter*/chapter*.xml

sed -e '/xreflabel/s|Host System Requirements|宿主系统需求|' \
	-i chapter02/hostreqs.xml

sed -e '/xreflabel/s|General Compilation Instructions|编译过程的一般说明|' \
	-i part3intro/generalinstructions.xml

sed -e '/xreflabel/s|Toolchain Technical Notes|工具链技术说明|' \
	-i part3intro/toolchaintechnotes.xml

sed -e '/xreflabel/s|Package build instructions|软件包构建说明|' \
	-i part3intro/generalinstructions.xml

sed -e '/xreflabel/s|"gcc-pass1"|"第一遍的 GCC"|' \
	-i chapter05/gcc-pass1.xml

sed -e '/xreflabel/s|"gcc-pass2"|"第二遍的 GCC"|' \
	-i chapter06/gcc-pass2.xml

sed -e '/xreflabel/s|Appendix|附录|' -i \
	appendices/acknowledgments.xml      \
	appendices/acronymlist.xml          \
	appendices/dependencies.xml         \
	appendices/license.xml              \
	appendices/scripts.xml              \
	appendices/udev-rules.xml

sed -e 's/Approximate build time/估计构建时间/'               \
	-e 's/Required disk space/需要硬盘空间/'                  \
	-e 's/Installation depends on/安装依赖于/'                \
	-e 's/Test suite depends on/测试依赖于/'                  \
	-e 's/Must be installed before/必须在下列软件包之前安装/' \
	-e 's/Optional dependencies/可选依赖项/'                  \
	-i  general.ent

sed -e 's/less than/不到/' \
	-e 's/typically about/一般约/' \
	-e 's/about \(.*\) with tests/计入测试为约 \1/' \
	-e '/encoding=/s/ISO-8859-1/UTF-8/' \
	-i  packages.ent

reldate=$(grep 'releasedate' general.ent.orig |
	      sed 's/.*"\(.*\)".*/\1/;s/st\|nd\|rd\|th//');
reldate_cn=$(LANG=en_US.UTF-8 \
             date -d "$reldate" "+%Y 年 %m 月 %d 日" \
             2>/dev/null | sed 's@ 0@ @g')
sed "/releasedate/s/\".*\"/\"${reldate_cn}\"/" -i general.ent

# Some buggy comments produced by po4a are adding extra empty lines.
# Remove them.
sed -n '
1h
1!{
	/<screen[^\n]*><!--.*-->\n/!H
	g
	/<screen[^\n]*><!--.*-->\n/{
		s/\(<screen[^\n]*>\)<!--.*-->\n/\1/
		p
		n
		h
	}
}
$p
'   -i \
	chapter06/ncurses.xml                        \
	chapter08/glibc.xml                          \
	chapter08/flex.xml                           \
	chapter08/ninja.xml                          \
	chapter08/texinfo.xml                        \
	chapter08/systemd.xml                        \
	chapter09/networkd.xml                       \
	chapter09/network.xml                        \
	chapter09/consoled.xml                       \
	chapter09/usage.xml

# Apply lfs-l10n.xml patch, if it's not applied
grep "Simplified Chinese" stylesheets/lfs-xsl/lfs-l10n.xml ||
	patch -N -p1 -i ../patches/lfs-l10n.xml.patch

# Opts in the xsl specifying fonts
cp -v ../zh_CN-fonts.xsl stylesheets/lfs-xsl/pdf/
grep zh_CN-fonts stylesheets/lfs-xsl/pdf.xsl ||
	sed '/<\/xsl:stylesheet>/i <xsl:include href="pdf/zh_CN-fonts.xsl"/>' \
	    -i stylesheets/lfs-xsl/pdf.xsl

# Edit Makefile
cp -v Makefile.orig Makefile

# Remove two seds causing encoding error in UTF-8
sed -e '/xa9/d' -i Makefile

# Copy fonts to tmp dir, and let fop to use our custom config
sed '/fop -q/i \\tmkdir -pv $(RENDERTMP)/fonts; cp -v fonts/* $(RENDERTMP)/fonts' -i Makefile

sed 's|fop -q|& -c ../fop.xml|' -i Makefile
