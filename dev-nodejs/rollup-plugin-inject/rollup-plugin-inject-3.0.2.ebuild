# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="rollup-plugin-inject"
inherit npm

DESCRIPTION="Scan modules for global variables and inject \`import\` statements where necessary"
HOMEPAGE="https://github.com/rollup/rollup-plugin-inject#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/estree-walker
	dev-nodejs/magic-string
	dev-nodejs/rollup-pluginutils
"
BDEPEND="${RDEPEND}"
