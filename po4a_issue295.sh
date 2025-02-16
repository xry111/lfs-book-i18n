#!/bin/sh
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
	chapter07/kernfs.xml                         \
	chapter08/glibc.xml                          \
	chapter08/lz4.xml                            \
	chapter08/flex.xml                           \
	chapter08/autoconf.xml                       \
	chapter08/gettext.xml                        \
	chapter08/ninja.xml                          \
	chapter08/findutils.xml                      \
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
	sed -n "${sed_cmd}" -i chapter08/glibc.xml chapter08/stripping.xml
done
