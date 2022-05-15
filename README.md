# Linux From Scratch 中文翻译项目

尽管本仓库名为 `lfs-book-i18n`
(因为理论上可以将其他语言的翻译也塞到本仓库中)，
但现在只有中文，因此本 README 文件的其余部分也只有中文。
如果您想贡献其他语言的翻译，请 (用中文或英文) 致信
`xry111@xry111.site`。

Though this repository is named `lfs-book-i18n` (theoratically we can add
more translations into it), now only Chinese translation is here.  So the
remaining part of this file would also be Chinese-only.  If you wish to
contribute other translations, please mail to `xry111@xry111.site`
(in English or Chinese).

## 使用方法

如果您只需要阅读手册，
访问[主页](https://lfs.xry111.site/zh_CN/)即可。
如果您希望自己从翻译文件生成手册，或者修改翻译文件，继续阅读。

首先安装依赖项：

* [po4a](https://po4a.org/) (>= 0.62)
* [polib](https://pypi.org/project/polib/)
* [libxml2](https://www.linuxfromscratch.org/blfs/view/svn/general/libxml2.html)
* [libxslt](https://www.linuxfromscratch.org/blfs/view/svn/general/libxslt.html)
* [DocBook 4.5 XML DTD](https://www.linuxfromscratch.org/blfs/view/svn/pst/docbook.html)
* [DocBook XSL Stylesheets](https://www.linuxfromscratch.org/blfs/view/svn/pst/docbook-xsl.html)
* [HTMLTidy](https://www.linuxfromscratch.org/blfs/view/svn/general/tidy-html5.html)

如果需要生成 PDF 格式的手册，还需要安装：

* [JDK](https://www.linuxfromscratch.org/blfs/view/svn/general/openjdk.html)
* [FOP](https://www.linuxfromscratch.org/blfs/view/svn/pst/fop.html)

克隆本仓库，并将英文原版 LFS 手册作为 Git submodule 一并检出：

```
git clone https://github.com/xry111/lfs-book-i18n --recurse-submodules
cd lfs-book-i18n
```

**如果**需要生成稳定版手册，切换到对应的分支：

```
git checkout 10.1 --recurse-submodules
```

注意：10.1 和之前版本的英文原版手册使用 SVN 进行版本控制。
如果需要生成它们，请参阅对应分支中的 `README.md` 文件。

之后即可生成手册：

```
make html nochunks pdf REV=sysv
```

生成的手册将位于 `zh_CN/book/render` 中。
将 `sysv` 改为 `systemd` 可以生成 systemd 版本的手册。
如果不需要单页 HTML 或 PDF 格式手册，可以从命令中删除对应的
`nochunks` 或者 `pdf`。

注意在生成 PDF 格式的手册时，会自动下载一些中文字体，可能额外消耗几十 MB
的流量。

如果您长期使用翻译项目，则可以在仓库中创建文件 `local.mk`，
设定 `REV` 的值，即可避免每次输入。如：

```
REV=systemd
```

## 参与翻译

如果对翻译有任何修改意见，请在 GitHub 仓库创建 Issue。

如果希望长期参与翻译，致信 `xry111@xry111.site` 提出，
以获得仓库的相关访问权限。
