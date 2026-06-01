# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="get-proto"
inherit npm

DESCRIPTION="Robustly get the [[Prototype]] of an object"
HOMEPAGE="https://github.com/ljharb/get-proto#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/dunder-proto
	dev-nodejs/es-object-atoms
"
BDEPEND="${RDEPEND}"
