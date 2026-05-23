# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="to-regex-range"

inherit npm

DESCRIPTION="Pass two numbers, get a regex-compatible source string for matching ranges. Validated against more than 2.78 million test assertions."
HOMEPAGE="https://github.com/micromatch/to-regex-range"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/is-number
"
BDEPEND=""
