# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="minimatch"
inherit npm

DESCRIPTION="a glob matcher in javascript"
HOMEPAGE="https://github.com/isaacs/minimatch#readme"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/brace-expansion
"
BDEPEND="${RDEPEND}"
