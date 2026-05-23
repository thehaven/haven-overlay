# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="parse-path"

inherit npm

DESCRIPTION="Parse paths (local paths, urls: ssh/git/etc)"
HOMEPAGE="https://github.com/IonicaBizau/parse-path"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/protocols
"
BDEPEND=""
