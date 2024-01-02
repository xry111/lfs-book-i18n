#!/usr/bin/env python3

import sys

print('[po4a_langs]', sys.argv[1])

print(r'''[po4a_paths] pot/$master.pot $lang:$lang/$master.po
[options] --porefs file
[options] --keep 0
[options] --package-name "\"Linux From Scratch\""
[options] --package-version 11.3
[options] --msgid-bugs-address lfs-dev@lists.linuxfromscratch.org
[options] --copyright-holder "\"Gerard Beekmans\""''')

pfx = 'lfs-en/'

files = sys.argv[2:]
files.sort()

for xml_en in files:
    if xml_en[:len(pfx)] != pfx or xml_en[-4:] != '.xml':
        raise Exception("unexpected path " + xml_en)
    out = "$lang:$lang/book/" + xml_en[len(pfx):]
    pot = "pot=" + xml_en[len(pfx):-4]
    print('[type: docbook]', xml_en, out, pot)
