# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils subversion

DESCRIPTION="A utility to automatically download enclosures and other objects
linked to from various types of RSS feeds. Works well on podcasts, videocasts,
and torrents. "
HOMEPAGE="https://code.google.com/p/rssdler/"

ESVN_REPO_URI="http://rssdler.googlecode.com/svn/trunk/"
ESVN_PROJECT="rssdler-snapshot"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="mechanize"

PYTHON_DEPEND="*"
DEPEND=""
RDEPEND="${DEPEND}
		dev-python/feedparser
		mechanize? ( dev-python/mechanize )"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	python_copy_sources
}

src_install() {
	distutils_src_install
}

pkg_postinst() {
	echo
	elog "You have now installed all the requirements for RSSDler as well as RSSDler itself"
	elog "You can run it with just \"rssdler -r\" anywhere, and it will find your config file at ~/.rssdler/config.txt"
	elog "Otherwise, specify the configuration file with -c."
	echo
	elog "For an example commented config file see: https://code.google.com/p/rssdler/wiki/CommentedConfig"
	echo
}
