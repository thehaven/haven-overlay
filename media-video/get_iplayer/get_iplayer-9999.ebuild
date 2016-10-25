# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git-r3

DESCRIPTION="BBC Iplayer downloading application"
HOMEPAGE="http://linuxcentre.net/get_iplayer/"
SRC_URI="" # ftp://ftp.infradead.org/pub/get_iplayer/${P}.tar.gz"
EGIT_REPO_URI="git://git.infradead.org/get_iplayer.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="|| ( media-video/mplayer
              media-video/mpv )
		virtual/ffmpeg
		media-sound/lame
		media-video/flvstreamer
		dev-perl/libwww-perl
		media-video/atomicparsley
		"
DEPEND=""

src_install() {
	dobin ${PN}
	doman ${PN}.1
	insinto /usr/share/${PN}/plugins
	doins plugins/*
}