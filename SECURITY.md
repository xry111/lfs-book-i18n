# Security Policy

[中文版本](SECURITY-zh_CN.md)

## Supported Versions

LFS is not a traditional distro, but a book telling people "how to".  So the
released book won't be updated for security fixes.  

Now, for items since LFS-10.0 (and BLFS-10.0) were released on 1st September
2020, advisories are (sometimes belatedly for 10.0 items) being documented.
There will be separate pages for each release of the book (covering up to
the next release) and there is also a consolidated page for all LFS and BLFS
security advisories.  The advisories are avaliable
[here](https://www.linuxfromscratch.org/lfs/advisories/).

Pre-releases (`x.y-rcz`) do not have security advisories.  Users building
them should take care on the changelog to identify security issues.

## Reporting a Vulnerability

For security issues in a package used by LFS book, report them to upstream
developers directly.  Do not disclose any security issue without upstream
approval.

For security issues in the LFS book itself (for example, using an outdated
package with security vulnerabilities, building a package without a critical
security feature recommended by upstream, or creating a vulnerable system
configuration), report to the editors and maintainers listed in
[here](https://www.linuxfromscratch.org/credits.html).  It's recommended not
to disclose a security issue without approval from the managing editor.

For security issues introduced by a mistranslation in this repo (unlikely
but it may happen), report to <xry111@mengyan1223.wang>.
