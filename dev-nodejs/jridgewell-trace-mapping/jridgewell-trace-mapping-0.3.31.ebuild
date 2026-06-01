# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@jridgewell/trace-mapping"
inherit npm

DESCRIPTION="Trace the original position through a source map"
HOMEPAGE="https://github.com/jridgewell/sourcemaps/tree/main/packages/trace-mapping"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/jridgewell-resolve-uri
	dev-nodejs/jridgewell-sourcemap-codec
"
BDEPEND="${RDEPEND}"
