# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="opencode-snippets"
inherit npm

DESCRIPTION="Hashtag-based snippet expansion plugin for OpenCode - instant inline text shortcuts"
HOMEPAGE="https://github.com/JosXa/opencode-snippets#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/gray-matter
	dev-nodejs/jsonc-parser
"
BDEPEND="${RDEPEND}"
