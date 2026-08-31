# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="openmemory-js"
NPM_AUTO_BIN=1
inherit npm

DESCRIPTION="OpenMemory Node SDK + server — self-hosted long-term memory for AI agents"
HOMEPAGE="https://github.com/CaviraOSS/LongMemory"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=net-libs/nodejs-20"

# openmemory-js ships a Node.js server (dist/server/index.js) plus an `opm`
# CLI bin that talks to it. The tarball installs the prebuilt dist + bundled
# node_modules so the server can run without an extra fetch step. This avoids
# the source-based build (which would need network access to fetch ~14 deps
# including the native sqlite3 module).
QA_PREBUILT="*.node"
