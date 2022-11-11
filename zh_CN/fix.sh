#!/bin/sh

# fix some English and ASCII specific stuff which can not be handled by po4a

# Set a UTF-8 locale, to prevent errors.
export LANG=en_US.utf8

# This should be handled by po4a, but if some pages are not done yet
# we will need to do it manually.
sed -e '/encoding=/s|ISO-8859-1|UTF-8|' -i $(find -name \*.xml)

# Let tidy output UTF-8
sed -e '/output-encoding:/s|latin1|utf8|' -i tidy.conf

sed -e 's|<book>|<book lang="zh_cn">|' -i index.xml

cp general.ent.orig general.ent

sed -e 's/Approximate build time/估计构建时间/'               \
	-e 's/Required disk space/需要硬盘空间/'                  \
	-e 's/Installation depends on/安装依赖于/'                \
	-e 's/Required at runtime/运行时依赖于/'                  \
	-e 's/Test suite depends on/测试依赖于/'                  \
	-e 's/Must be installed before/必须在下列软件包之前安装/' \
	-e 's/Optional dependencies/可选依赖项/'                  \
	-i  general.ent

sed -e 's/less than/不到/' \
	-e 's/typically about/一般约/' \
	-e 's/about \(.*\) with tests/计入测试时间为约 \1/' \
	-e 's/with tests/已计入测试时间/' \
	-e '/encoding=/s/ISO-8859-1/UTF-8/' \
	-e 's/\([0-9.]* SBU\) on a spinning disk, \(.* SBU\) on an SSD/机械硬盘上 \1，固态硬盘上 \2/' \
	-i  packages.ent

reldate=$(grep '% reldate' general.ent.orig |
             sed 's/.*"\(.*\)".*/\1/;s/\(st\|nd\|rd\|th\),/,/');
reldate_cn=$(date -d "$reldate" "+%Y 年 %m 月 %d 日" \
             2>/dev/null | sed 's@ 0@ @g')
sed "/% reldate/s/\".*\"/\"${reldate_cn}\"/" -i general.ent

# Edit git-version.sh
cp -v git-version.sh.orig git-version.sh
sed '/full_date=/ i month_zh_cn=$(date -d "$commit_date" "+%m" | sed "s/^0//")' \
	-i git-version.sh
sed '/full_date=/ s@".*"@"$year 年 $month_zh_cn 月 $day 日"@' \
	-i git-version.sh

# Fixup for https://github.com/mquinson/po4a/issues/295
sed_cmd='
1h
1!{
	/<screen[^\n]*><!--.*-->\n/!H
	g
	/<screen[^\n]*><!--.*-->\n/{
		s/\(<screen[^\n]*>\)\(\(<!--.*-->\)\+\n\)\+/\1/
		p
		n
		h
	}
}
$p
'

sed -n "${sed_cmd}" -i \
	chapter06/ncurses.xml                        \
	chapter08/glibc.xml                          \
	chapter08/flex.xml                           \
	chapter08/autoconf.xml                       \
	chapter08/gettext.xml                        \
	chapter08/ninja.xml                          \
	chapter08/texinfo.xml                        \
	chapter08/systemd.xml                        \
	chapter08/shadow.xml                         \
	chapter08/stripping.xml                      \
	chapter09/networkd.xml                       \
	chapter09/network.xml                        \
	chapter09/consoled.xml                       \
	chapter09/usage.xml

# Looks stupid, but I don't know any better way.
for iter in 1 2 3; do
	sed -n "${sed_cmd}" -i chapter08/{glibc,stripping}.xml
done

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
sed '/fop -q/i \\trm -rfv $(RENDERTMP)/fonts; ln -sv $(CURDIR)/fonts $(RENDERTMP)/fonts' -i Makefile

cp ../fop.xml .
sed 's|fop -q|& -c fop.xml|' -i Makefile

cp ../fonts.mk ../noto-cjk-commit ../source-han-mono-commit .
echo 'include fonts.mk' >> Makefile
