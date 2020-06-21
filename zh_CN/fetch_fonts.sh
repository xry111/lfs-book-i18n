#!/bin/sh

mkdir fonts -pv

if ! md5sum -c ../fonts.md5; then
	awk '{print $2}' ../fonts.md5 | wget -c -i - \
		-B "https://bf.mengyan1223.wang/lfs/" \
		--directory-prefix=fonts
fi
