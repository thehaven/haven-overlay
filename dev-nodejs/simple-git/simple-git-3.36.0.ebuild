# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="simple-git"
inherit npm

DESCRIPTION="Simple GIT interface for node.js"
HOMEPAGE="https://github.com/steveukx/git-js#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/debug
	dev-nodejs/kwsites-file-exists
	dev-nodejs/kwsites-promise-deferred
	dev-nodejs/simple-git-args-pathspec
	dev-nodejs/simple-git-argv-parser
"
BDEPEND="${RDEPEND}"
