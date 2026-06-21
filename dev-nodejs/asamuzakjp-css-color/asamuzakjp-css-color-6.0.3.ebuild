# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@asamuzakjp/css-color"
inherit npm

DESCRIPTION="CSS color - Resolve and convert CSS colors."
HOMEPAGE="https://github.com/asamuzaK/cssColor#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/asamuzakjp-generational-cache
	dev-nodejs/csstools-css-calc
	dev-nodejs/csstools-css-color-parser
	dev-nodejs/csstools-css-parser-algorithms
	dev-nodejs/csstools-css-tokenizer
"
BDEPEND="${RDEPEND}"
