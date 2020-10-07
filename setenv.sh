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

branch="$(echo $1 | sed 's@^refs/heads/@@')"
svn_branch="trunk/BOOK"

echo "${branch}"

case "${branch}" in
	*/*)
		echo "UPLOAD=no" >> $GITHUB_ENV
		exit 0
		;;
	master)
		sysv="development"
		sysd="systemd"
		;;
	*-rc*)
		sysv="${branch}"
		sysd="$(echo \"${branch}\" | sed 's@-@-systemd-@')"
		svn_branch="${branch}"
		;;
	*)
		sysv="${branch}"
		sysd="${branch}-systemd"
		svn_branch="${branch}"
		;;
esac

echo "UPLOAD=yes" >> $GITHUB_ENV
echo "SYSV=${sysv}" >> $GITHUB_ENV
echo "SYSD=${sysd}" >> $GITHUB_ENV
echo "SVN_BRANCH=${svn_branch}" >> $GITHUB_ENV
