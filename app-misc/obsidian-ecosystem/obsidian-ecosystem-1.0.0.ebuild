# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta-package for the full Elite Obsidian SRE ecosystem"
HOMEPAGE="https://github.com/haven/ObsidianSetup"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+binary +source-runtimes"

# Note: We prioritize binary for the core app by default as it's proprietary,
# but allow source-based components for KasmVNC and runtimes.

RDEPEND="
	binary? ( 
		app-editors/obsidian-bin
		net-misc/kasmvnc-bin
	)
	!binary? ( 
		app-editors/obsidian
		net-misc/kasmvnc
	)
	dev-util/obsidian-mcp
	app-admin/obsidian-manager
	app-text/obsidian-export
	source-runtimes? (
		dev-lang/deno
		dev-lang/bun
	)
	!source-runtimes? (
		dev-lang/deno-bin
		dev-lang/bun-bin
	)
"

S="${WORKDIR}"
