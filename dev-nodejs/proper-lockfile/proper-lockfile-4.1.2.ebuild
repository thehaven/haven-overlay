# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="proper-lockfile"
inherit npm

DESCRIPTION="A inter-process and inter-machine lockfile utility that works on a local or network file system"
HOMEPAGE="https://github.com/moxystudio/node-proper-lockfile"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/graceful-fs
	dev-nodejs/retry
	dev-nodejs/signal-exit
"
BDEPEND="${RDEPEND}"
