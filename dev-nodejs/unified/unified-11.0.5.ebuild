# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="unified"

inherit npm

DESCRIPTION="parse, inspect, transform, and serialize content through syntax trees"
HOMEPAGE="https://unifiedjs.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/bail
	dev-nodejs/devlop
	dev-nodejs/extend
	dev-nodejs/is-plain-obj
	dev-nodejs/trough
	dev-nodejs/types-unist
	dev-nodejs/vfile
"
BDEPEND=""
