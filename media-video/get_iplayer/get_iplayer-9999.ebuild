# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3

DESCRIPTION="BBC Iplayer downloading application"
HOMEPAGE="http://linuxcentre.net/get_iplayer/"
EGIT_REPO_URI="https://github.com/get-iplayer/get_iplayer.git"
EGIT_BRANCH='master'

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="**"
IUSE=""

RDEPEND="|| ( media-video/mplayer
              media-video/mpv )
		virtual/ffmpeg
		media-sound/lame
		media-video/flvstreamer
		dev-perl/libwww-perl
		dev-perl/XML-LibXML
		media-video/atomicparsley
		"
DEPEND=""

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
