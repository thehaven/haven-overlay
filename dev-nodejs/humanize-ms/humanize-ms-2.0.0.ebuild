# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="humanize-ms"

inherit npm

DESCRIPTION="transform humanize time to ms"
HOMEPAGE="https://github.com/node-modules/humanize-ms#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/ms
"
BDEPEND="${RDEPEND}"
