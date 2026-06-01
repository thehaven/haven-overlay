# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="type-fest"
inherit npm

DESCRIPTION="A collection of essential TypeScript types"
HOMEPAGE="https://github.com/sindresorhus/type-fest#readme"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/tagged-tag
"
BDEPEND="${RDEPEND}"
