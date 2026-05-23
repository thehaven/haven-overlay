# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@pnpm/text.comments-parser"

inherit npm

DESCRIPTION="Extracts and inserts comments from/to text"
HOMEPAGE="https://github.com/pnpm/pnpm/tree/main/text/comments-parser#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/strip-comments-strings
"
BDEPEND="${RDEPEND}"
