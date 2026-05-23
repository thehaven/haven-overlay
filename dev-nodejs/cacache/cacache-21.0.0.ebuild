# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="cacache"

inherit npm

DESCRIPTION="Fast, fault-tolerant, cross-platform, disk-based, data-agnostic, content-addressable cache."
HOMEPAGE="https://github.com/npm/cacache#readme"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/fs-minipass
	dev-nodejs/glob
	dev-nodejs/lru-cache
	dev-nodejs/minipass
	dev-nodejs/minipass-collect
	dev-nodejs/minipass-flush
	dev-nodejs/minipass-pipeline
	dev-nodejs/npmcli-fs
	dev-nodejs/p-map
	dev-nodejs/ssri
"
BDEPEND=""
