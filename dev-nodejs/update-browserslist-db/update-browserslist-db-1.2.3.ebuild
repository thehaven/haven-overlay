# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="update-browserslist-db"
inherit npm

DESCRIPTION="CLI tool to update caniuse-lite to refresh target browsers from Browserslist config"
HOMEPAGE="https://github.com/browserslist/update-db#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/escalade
	dev-nodejs/picocolors
"
BDEPEND="${RDEPEND}"
