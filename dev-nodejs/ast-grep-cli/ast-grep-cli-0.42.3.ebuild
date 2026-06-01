# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@ast-grep/cli"
inherit npm

DESCRIPTION="Search and Rewrite code at large scale using precise AST pattern"
HOMEPAGE="https://ast-grep.github.io"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/detect-libc
"
BDEPEND="${RDEPEND}"
