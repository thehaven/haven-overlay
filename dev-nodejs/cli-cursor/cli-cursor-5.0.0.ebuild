# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="cli-cursor"
inherit npm

DESCRIPTION="Toggle the CLI cursor"
HOMEPAGE="https://github.com/sindresorhus/cli-cursor#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/restore-cursor
"
BDEPEND="${RDEPEND}"
