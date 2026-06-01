# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opentui/core"
inherit npm

DESCRIPTION="OpenTUI is a TypeScript library on a native Zig core for building terminal user interfaces (TUIs)"
HOMEPAGE="https://github.com/anomalyco/opentui#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/bun-ffi-structs
	dev-nodejs/diff
	dev-nodejs/marked
	dev-nodejs/string-width
	dev-nodejs/strip-ansi
	dev-nodejs/yoga-layout
"
BDEPEND="${RDEPEND}"
