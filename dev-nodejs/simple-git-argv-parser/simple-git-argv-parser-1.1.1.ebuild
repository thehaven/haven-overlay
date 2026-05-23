# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@simple-git/argv-parser"
inherit npm

DESCRIPTION="Node.js module"
HOMEPAGE="https://github.com/steveukx/git-js#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/simple-git-args-pathspec
"
BDEPEND="${RDEPEND}"
