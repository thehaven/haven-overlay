# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="estree-walker"
inherit npm

DESCRIPTION="Traverse an ESTree-compliant AST"
HOMEPAGE="https://github.com/Rich-Harris/estree-walker#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-estree
"
BDEPEND="${RDEPEND}"
