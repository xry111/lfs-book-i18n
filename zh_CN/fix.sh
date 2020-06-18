#!/bin/sh

# fix some English and ASCII specific stuff which can not be handled by po4a

# This should be handled by po4a, but if some pages are not done yet
# we will need to do it manually.
sed -e '/encoding=/s|ISO-8859-1|UTF-8|' -i $(find -name \*.xml)

# Let tidy output UTF-8
sed -e '/output-encoding:/s|latin1|utf8|' -i tidy.conf

# Remove two seds causing encoding error in UTF-8
sed -e '/xa9/d' -i Makefile

sed -e '/xreflabel/s|Chapter.nbsp.1 - Mailing Lists|第 1 章 - 邮件列表|' \
	-e '/xreflabel/s|Chapter.nbsp.1 - Mirror sites|第 1 章 - 镜像站|'    \
	-i chapter01/resources.xml

sed -e '/xreflabel/s|Chapter.nbsp.\([0-9]\+\)|第 \1 章|' \
	-i chapter*/chapter*.xml

sed -e '/xreflabel/s|Host System Requirements|宿主系统需求|' \
	-i chapter02/hostreqs.xml

sed -e '/xreflabel/s|General Compilation Instructions|通用编译说明|' \
	-i part3intro/generalinstructions.xml

sed -e '/xreflabel/s|Toolchain Technical Notes|工具链技术说明|' \
	-i part3intro/toolchaintechnotes.xml

sed -e '/xreflabel/s|Appendix|附录|' -i \
	appendices/acknowledgments.xml     \
	appendices/acronymlist.xml          \
	appendices/dependencies.xml         \
	appendices/license.xml              \
	appendices/scripts.xml              \
	appendices/udev-rules.xml
