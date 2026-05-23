# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="jsonc-weaver"
inherit npm

DESCRIPTION="Modify JSONC files programmatically while preserving comments and formatting."
HOMEPAGE="https://github.com/felipecrs/jsonc-weaver#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/jsonc-morph
"
BDEPEND="${RDEPEND}"
