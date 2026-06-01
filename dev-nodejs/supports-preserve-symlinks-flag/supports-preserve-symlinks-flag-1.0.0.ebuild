# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="supports-preserve-symlinks-flag"
inherit npm

DESCRIPTION="Determine if the current node version supports the \`--preserve-symlinks\` flag."
HOMEPAGE="https://github.com/inspect-js/node-supports-preserve-symlinks-flag#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="

"
BDEPEND="${RDEPEND}"
