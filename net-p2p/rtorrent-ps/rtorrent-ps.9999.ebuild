# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit distutils-r1 eutils

if [[ ${PV} = 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="	git://github.com/pyroscope/rtorrent-ps.git
        			https://github.com/pyroscope/rtorrent-ps.git"
fi

DESCRIPTION="Extended rTorrent distribution with UI enhancements, colorization, and some added features."
HOMEPAGE="https://github.com/pyroscope/rtorrent-ps"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
