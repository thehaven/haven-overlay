# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="git-up"


DESCRIPTION="A low level git url parser."
HOMEPAGE="https://github.com/IonicaBizau/git-up"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/is-ssh
	dev-nodejs/parse-url
"
BDEPEND=""
