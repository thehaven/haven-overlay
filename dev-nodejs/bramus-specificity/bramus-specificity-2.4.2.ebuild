# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@bramus/specificity"
inherit npm

DESCRIPTION="Calculate specificity of a CSS Selector"
HOMEPAGE="https://github.com/bramus/specificity#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/css-tree
"
BDEPEND="${RDEPEND}"
