# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

inherit git-r3

DESCRIPTION="Enterprise scalable realtime graphing"
HOMEPAGE="https://github.com/vimeo/graph-explorer"
EGIT_REPO_URI="https://github.com/vimeo/graph-explorer.git"
EGIT_OPTIONS="--recurse-submodules=yes --progress"
EGIT_HAS_SUBMODULES=true

SLOT="0"
LICENSE=""
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/graphite-web
	dev-python/rawes"

src_prepare() {
	cd ${WORKDIR}/${P}/ && git submodule update --init --recursive || die "Failed git submodule recurse"
}

src_install() {
	insinto /opt/graph-explorer
	doins -r ${WORKDIR}/${P}/*
}
