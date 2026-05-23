# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="remark-github"

inherit npm

DESCRIPTION="remark plugin to autolink references like in GitHub issues, PRs, and comments"
HOMEPAGE="https://github.com/remarkjs/remark-github#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/mdast-util-find-and-replace
	dev-nodejs/mdast-util-to-string
	dev-nodejs/to-vfile
	dev-nodejs/types-mdast
	dev-nodejs/unist-util-visit
	dev-nodejs/vfile
"
BDEPEND="${RDEPEND}"
