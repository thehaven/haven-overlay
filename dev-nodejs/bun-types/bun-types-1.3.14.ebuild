# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="bun-types"
inherit npm

DESCRIPTION="Type definitions and documentation for Bun, an incredibly fast JavaScript runtime"
HOMEPAGE="https://bun.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-node
"
BDEPEND="${RDEPEND}"
