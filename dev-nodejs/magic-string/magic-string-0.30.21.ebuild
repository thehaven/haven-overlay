# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="magic-string"
inherit npm

DESCRIPTION="Modify strings, generate sourcemaps"
HOMEPAGE="https://github.com/Rich-Harris/magic-string#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/jridgewell-sourcemap-codec
"
BDEPEND="${RDEPEND}"
