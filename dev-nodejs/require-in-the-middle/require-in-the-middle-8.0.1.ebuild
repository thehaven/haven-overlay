# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="require-in-the-middle"
inherit npm

DESCRIPTION="Module to hook into the Node.js require function"
HOMEPAGE="https://github.com/nodejs/require-in-the-middle#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/debug
	dev-nodejs/module-details-from-path
"
BDEPEND="${RDEPEND}"
