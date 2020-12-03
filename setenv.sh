#!/bin/sh

# only upload for branches
case "$1" in
	refs/heads/*)
		;;
	*)
		echo "UPLOAD=no" >> $GITHUB_ENV
		exit 0
		;;
esac

upload=yes
branch="$(echo $1 | sed 's@^refs/heads/@@')"
svn_branch="trunk/BOOK"

echo "${branch}"

case "${branch}" in
	*/*)
		upload=no
		;;
	master)
		sysv="development"
		sysd="systemd"
		;;
	*-rc*)
		sysv="${branch}"
		sysd="$(echo \"${branch}\" | sed 's@-@-systemd-@')"
		svn_branch="tags/${branch}"
		;;
	*)
		sysv="${branch}"
		sysd="${branch}-systemd"
		svn_branch="tags/${branch}"
		;;
esac

echo "UPLOAD=${upload}" >> $GITHUB_ENV
echo "SYSV=${sysv}" >> $GITHUB_ENV
echo "SYSD=${sysd}" >> $GITHUB_ENV
echo "SVN_BRANCH=${svn_branch}" >> $GITHUB_ENV
