# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="rollup-plugin-node-polyfills"
inherit npm

DESCRIPTION="rollup-plugin-node-polyfills ==="
HOMEPAGE="https://github.com/ionic-team/rollup-plugin-node-polyfills#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/rollup-plugin-inject
"
BDEPEND="${RDEPEND}"
