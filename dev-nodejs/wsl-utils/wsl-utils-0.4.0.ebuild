# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="wsl-utils"
inherit npm

DESCRIPTION="Utilities for working with Windows Subsystem for Linux (WSL)"
HOMEPAGE="https://github.com/sindresorhus/wsl-utils#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/is-wsl
	dev-nodejs/powershell-utils
"
BDEPEND="${RDEPEND}"
