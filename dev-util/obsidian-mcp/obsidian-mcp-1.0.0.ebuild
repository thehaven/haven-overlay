# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Native MCP sidecar for Obsidian"
HOMEPAGE="https://github.com/haven/obsidian-mcp"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=net-libs/nodejs-18
"

S="${WORKDIR}"

src_install() {
	insinto /opt/obsidian-mcp
	doins "${FILESDIR}/index.js"
	
	systemd_dounit "${FILESDIR}/obsidian-mcp@.service"
	
	# Create a wrapper script
	cat <<-'INNER_EOF' > obsidian-mcp
		#!/bin/bash
		cd /opt/obsidian-mcp
		if [ ! -d "node_modules" ]; then
			npm install @modelcontextprotocol/sdk axios --silent
		fi
		exec node index.js "$@"
	INNER_EOF
	
	dobin obsidian-mcp
}
