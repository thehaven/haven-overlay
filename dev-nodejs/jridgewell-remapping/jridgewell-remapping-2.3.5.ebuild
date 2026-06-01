# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@jridgewell/remapping"
inherit npm

DESCRIPTION="Remap sequential sourcemaps through transformations to point at the original source code"
HOMEPAGE="https://github.com/jridgewell/sourcemaps/tree/main/packages/remapping"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/jridgewell-gen-mapping
	dev-nodejs/jridgewell-trace-mapping
"
BDEPEND="${RDEPEND}"
