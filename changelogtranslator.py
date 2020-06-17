#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
import re
from templatetranslator import TemplateTranslator

languages = sys.argv
languages.pop(0)
files=['chapter01/changelog.po']

tt = TemplateTranslator(files)

tt.append(re.compile('\[([^\]]+)\] - Updated? to ([^ ]+). +Fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL),
	{'fr': '[#1] — Mise à jour vers #2. Corrige #3',
         'zh_CN': '[#1] — 更新到 #2。修复 #3。'})
tt.append(re.compile('\[([^\]]+)\] - Updated? to ([^ ]+). +Partially fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL),
	{'fr': '[#1] — Mise à jour vers #2. Corrige partiellement #3',
         'zh_CN': '[#1] — 更新到 #2。部分修复 #3。'})
tt.append(re.compile('\[([^\]]+)\] - Updated? to ([^ ]+) (\([^ ]+\)). +Fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL),
	{'fr': '[#1] — Mise à jour vers #2 #3. Corrige #4',
         'zh_CN': '[#1] — 更新到 #2 #3。修复#4。'})
tt.append(re.compile('\[([^\]]+)\] - Updated? to ([^ ]+) \(([^ ]+) module\). +Fixes (<ulink [^>]+> *#[0-9]+ *</ulink>).?$', re.MULTILINE|re.DOTALL),
	{'fr': '[#1] — Mise à jour vers #2 (module #3). Corrige #4',
         'zh_CN': '[#1] — 更新到 #2（模块 #3）。修复 #4。'})
tt.append(re.compile('(20[0-9]{2})-(0?)([0-9]+)-(0?)([0-9]+)'),
	{'fr': '#4#5-#2#3-#1',
         'zh_CN': '#1 年 #3 月 #5 日'})

tt.translate(languages)
