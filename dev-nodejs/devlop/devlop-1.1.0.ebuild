# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="devlop"

inherit npm

DESCRIPTION="Do things in development and nothing otherwise"
HOMEPAGE="https://github.com/wooorm/devlop#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/dequal
"
BDEPEND="${RDEPEND}"
