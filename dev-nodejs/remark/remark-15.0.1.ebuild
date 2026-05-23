# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="remark"

inherit npm

DESCRIPTION="markdown processor powered by plugins part of the unified collective"
HOMEPAGE="https://remark.js.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/remark-parse
	dev-nodejs/remark-stringify
	dev-nodejs/types-mdast
	dev-nodejs/unified
"
BDEPEND="${RDEPEND}"
