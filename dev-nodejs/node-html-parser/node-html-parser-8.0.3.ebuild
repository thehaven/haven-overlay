# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="node-html-parser"


DESCRIPTION="A very fast HTML parser, generating a simplified DOM, with basic element query support."
HOMEPAGE="https://github.com/taoqf/node-fast-html-parser"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/css-select
	dev-nodejs/he
"
BDEPEND=""
