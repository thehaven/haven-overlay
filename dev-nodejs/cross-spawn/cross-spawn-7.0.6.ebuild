# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="cross-spawn"


DESCRIPTION="Cross platform child_process#spawn and child_process#spawnSync"
HOMEPAGE="https://github.com/moxystudio/node-cross-spawn"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/path-key
	dev-nodejs/shebang-command
	dev-nodejs/which
"
BDEPEND=""
