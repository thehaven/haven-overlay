# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="yargs"
inherit npm

DESCRIPTION="yargs the modern, pirate-themed, successor to optimist."
HOMEPAGE="https://yargs.js.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/cliui
	dev-nodejs/escalade
	dev-nodejs/get-caller-file
	dev-nodejs/string-width
	dev-nodejs/y18n
	dev-nodejs/yargs-parser
"
BDEPEND="${RDEPEND}"
