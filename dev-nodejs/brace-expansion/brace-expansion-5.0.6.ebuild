# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="brace-expansion"

inherit npm

DESCRIPTION="Brace expansion as known from sh/bash"
HOMEPAGE="https://github.com/juliangruber/brace-expansion#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/balanced-match
"
BDEPEND=""
