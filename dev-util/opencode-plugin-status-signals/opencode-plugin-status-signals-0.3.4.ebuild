# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@guard22/opencode-status-signals"
NPM_FILES="src package.json"
inherit npm

DESCRIPTION="Visual status signals for OpenCode sessions with in-app theme mapping"
HOMEPAGE="https://github.com/floze-the-genius/opencode-status-signals"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=net-libs/nodejs-20"
