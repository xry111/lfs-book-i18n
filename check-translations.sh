#!/bin/sh

# ensure there are no untranslated or fuzzy strings

export LC_MESSAGES=C

exitcode=0

for i in $(find -name \*.po); do
	if msgfmt -v $i -o /dev/null 2>&1 | tee msg | grep -E -v '^[0-9]+ translated message(s?).$' > /dev/null; then
		echo -n "$i: "
		cat msg
		if [ "$GITHUB_ACTIONS" = "true" ]; then
			cat $i
		fi
		exitcode=1
	fi
done

rm -f msg messages.mo
exit $exitcode
