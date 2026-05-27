# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="typescript-language-server"
inherit npm

DESCRIPTION="LSP implementation for TypeScript using tsserver"
HOMEPAGE="https://www.npmjs.com/package/typescript-language-server"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

pkg_postinst() {
	einfo "typescript-language-server ${PV} installed."
	einfo ""
	einfo "Add to ~/.config/opencode/opencode.json lsp section:"
	einfo "  \"typescript\": {"
	einfo "    \"command\": [\"node\", \"/usr/$(get_libdir)/node_modules/typescript-language-server/lib/cli.mjs\", \"--stdio\"]"
	einfo "  }"
}
