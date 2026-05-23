# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="dtrace-provider"

inherit npm

DESCRIPTION="Native DTrace providers for node.js applications"
HOMEPAGE="https://github.com/chrisa/node-dtrace-provider#readme"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/nan
"
BDEPEND="${RDEPEND}"
