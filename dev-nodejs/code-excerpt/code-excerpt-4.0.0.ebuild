# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="code-excerpt"
inherit npm

DESCRIPTION="Extract code excerpts"
HOMEPAGE="https://github.com/vadimdemedes/code-excerpt#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/convert-to-spaces
"
BDEPEND="${RDEPEND}"
