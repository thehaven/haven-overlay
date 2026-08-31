# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="opencode-history-search"
NPM_FILES="dist package.json"
inherit npm

DESCRIPTION="Search OpenCode conversation history across projects with fuzzy + SQL search"
HOMEPAGE="https://github.com/joeyism/opencode-history-search"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Runtime dep on bun: plugin entry dist/history-search.ts is a TS file
# executed via the Bun runtime by OpenCode.
RDEPEND=">=net-libs/nodejs-20
	|| ( dev-lang/bun-bin dev-lang/bun )"
