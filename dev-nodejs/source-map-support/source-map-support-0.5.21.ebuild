# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="source-map-support"
inherit npm

DESCRIPTION="Fixes stack traces for files with source maps"
HOMEPAGE="https://github.com/evanw/node-source-map-support#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/buffer-from
	dev-nodejs/source-map
"
BDEPEND="${RDEPEND}"
