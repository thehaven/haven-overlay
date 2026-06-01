# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="is-wsl"
inherit npm

DESCRIPTION="Check if the process is running inside Windows Subsystem for Linux (Bash on Windows)"
HOMEPAGE="https://github.com/sindresorhus/is-wsl#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/is-inside-container
"
BDEPEND="${RDEPEND}"
