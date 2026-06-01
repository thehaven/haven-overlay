# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="css-tree"
inherit npm

DESCRIPTION="A tool set for CSS: fast detailed parser (CSS → AST), walker (AST traversal), generator (AST → CSS) and lexer (validation and matching) based on specs and browser implementations"
HOMEPAGE="https://github.com/csstree/csstree#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/mdn-data
	dev-nodejs/source-map-js
"
BDEPEND="${RDEPEND}"
