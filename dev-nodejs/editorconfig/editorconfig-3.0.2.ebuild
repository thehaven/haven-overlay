# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="editorconfig"
inherit npm

DESCRIPTION="EditorConfig File Locator and Interpreter for Node.js"
HOMEPAGE="https://github.com/editorconfig/editorconfig-core-js#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/commander
	dev-nodejs/minimatch
	dev-nodejs/one-ini-wasm
	dev-nodejs/semver
"
BDEPEND="${RDEPEND}"
