# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="git-url-parse"

inherit npm

DESCRIPTION="A high level git url parser for common git providers."
HOMEPAGE="https://github.com/IonicaBizau/git-url-parse"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/git-up
"
BDEPEND=""
