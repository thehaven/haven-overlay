# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="Enterprise scalable realtime graphing"
HOMEPAGE="https://github.com/vimeo/graph-explorer"
EGIT_REPO_URI="https://github.com/vimeo/graph-explorer.git"

SLOT="0"
LICENSE=""
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/graphite-web
	dev-python/rawes"

src_prepare() {
    echo "Cloning timeserieswidget files into /timeserieswidget:"
	cd ${WORKDIR}/${P} && git clone https://github.com/vimeo/timeserieswidget.git
}

src_install() {
	insinto /opt/graph-explorer
	doins -r ${WORKDIR}/${P}/*
}
