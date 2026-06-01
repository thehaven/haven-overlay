# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="restore-cursor"
inherit npm

DESCRIPTION="Gracefully restore the CLI cursor on exit"
HOMEPAGE="https://github.com/sindresorhus/restore-cursor#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/onetime
	dev-nodejs/signal-exit
"
BDEPEND="${RDEPEND}"
