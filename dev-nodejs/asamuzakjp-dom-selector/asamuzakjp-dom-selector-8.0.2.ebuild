# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@asamuzakjp/dom-selector"
inherit npm

DESCRIPTION="A CSS selector engine."
HOMEPAGE="https://github.com/asamuzaK/domSelector#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/asamuzakjp-generational-cache
	dev-nodejs/bidi-js
	dev-nodejs/css-tree
	dev-nodejs/is-potential-custom-element-name
"
BDEPEND="${RDEPEND}"
