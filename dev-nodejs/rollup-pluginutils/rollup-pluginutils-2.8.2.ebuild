# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="rollup-pluginutils"
inherit npm

DESCRIPTION="Functionality commonly needed by Rollup plugins"
HOMEPAGE="https://github.com/rollup/rollup-pluginutils#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/estree-walker
"
BDEPEND="${RDEPEND}"
