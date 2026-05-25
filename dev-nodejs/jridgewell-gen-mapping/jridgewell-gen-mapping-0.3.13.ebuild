# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@jridgewell/gen-mapping"
inherit npm

DESCRIPTION="Generate source maps"
HOMEPAGE="https://github.com/jridgewell/sourcemaps/tree/main/packages/gen-mapping"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/jridgewell-sourcemap-codec
	dev-nodejs/jridgewell-trace-mapping
"
BDEPEND="${RDEPEND}"
