#!/bin/sh

source ./merge-local.sh

export LC_MESSAGES=C

for i in $(find -name \*.po); do
	if msgfmt -v $i -o /dev/null 2>&1 | grep -E -v '^[0-9]+ translated message(s?).$' > /dev/null; then
		msgmerge $MASTER_WORKTREE/$i $i -o $i -N
	fi
done

rm -f messages.mo
