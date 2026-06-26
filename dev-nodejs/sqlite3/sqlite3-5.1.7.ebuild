# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

DESCRIPTION="Asynchronous, non-blocking SQLite3 bindings"
HOMEPAGE="https://github.com/TryGhost/node-sqlite3"

LICENSE="BSD-3-Clause"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

QA_PREBUILT='*.node'
RESTRICT='strip'

RDEPEND=""
BDEPEND="${RDEPEND}"
