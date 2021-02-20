# Linux From Scratch 中文翻译项目

尽管本仓库名为 `lfs-book-i18n`
(因为理论上可以将其他语言的翻译也塞到本仓库中)，
但现在只有中文，因此本 README 文件的其余部分也只有中文。
如果您想贡献其他语言的翻译，请 (用中文或英文) 致信
`xry111@mengyan1223.wang`。

Though this repository is named `lfs-book-i18n` (theoratically we can add
more translations into it), now only Chinese translation is here.  So the
remaining part of this file would also be Chinese-only.  If you wish to
contribute other translations, please mail to `xry111@mengyan1223.wang`
(in English or Chinese).

## 使用方法

如果您只需要阅读手册，
访问[主页](https://bf.mengyan1223.wang/lfs/zh_CN/)即可。
如果您希望自己从翻译文件生成手册，或者修改翻译文件，继续阅读。

首先安装依赖项：

* [po4a](https://po4a.org/) (>= 0.62)
* [polib](https://pypi.org/project/polib/)
* [libxml2](http://www.linuxfromscratch.org/blfs/view/svn/general/libxml2.html)
* [libxslt](http://www.linuxfromscratch.org/blfs/view/svn/general/libxslt.html)
* [DocBook DTD](http://www.linuxfromscratch.org/blfs/view/svn/pst/xml.html)
* [DocBook XSL Stylesheets](http://www.linuxfromscratch.org/blfs/view/svn/pst/docbook-xsl.html)
* [HTMLTidy](http://www.linuxfromscratch.org/blfs/view/svn/general/tidy-html5.html)

如果需要生成 PDF 格式的手册，还需要安装：

* [JDK](http://www.linuxfromscratch.org/blfs/view/svn/general/openjdk.html)
* [FOP](http://www.linuxfromscratch.org/blfs/view/svn/pst/fop.html)

本仓库只包含翻译，因此需要通过 SVN 签出原始的 LFS 手册 XML 文件：

```
svn co http://svn.linuxfromscratch.org/lfs/trunk/BOOK /local/path/to/lfs/en
```

上面的例子会签出最新的开发版 LFS 手册。
**如果**需要生成稳定版手册，则签出对应的版本 (以 10.0 为例)：

```
svn co http://svn.linuxfromscratch.org/lfs/tags/10.0 /local/path/to/lfs/en
```

然后克隆出本仓库：

```
git clone https://git.mengyan1223.wang/xry111/lfs-book-i18n
cd lfs-book-i18n
```

**如果**需要生成稳定版手册，切换到对应的分支：

```
git checkout 10.0
```

之后即可生成手册：

```
make html nochunks pdf REV=sysv LFS_EN=/local/path/to/lfs/en
```

生成的手册将位于 `zh_CN/book/render` 中。
将 `sysv` 改为 `systemd` 可以生成 systemd 版本的手册。
如果不需要单页 HTML 或 PDF 格式手册，可以从命令中删除对应的
`nochunks` 或者 `pdf`。

注意在生成 PDF 格式的手册时，会自动下载一些中文字体，可能额外消耗几十 MB
的流量。

如果您长期使用翻译项目，则可以在仓库中创建文件 `local.mk`，
设定 `REV` 和 `LFS_EN` 的值，即可避免每次输入。如：

```
REV=systemd
LFS_EN=$(HOME)/lfs_en
```

## 参与翻译

如果对翻译有任何修改意见，请在 GitHub 仓库创建 Issue。

如果希望长期参与翻译，致信 `xry111@mengyan1223.wang` 提出，
以获得仓库的相关访问权限。
