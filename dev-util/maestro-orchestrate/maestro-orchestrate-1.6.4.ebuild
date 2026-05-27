# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Multi-agent development orchestration platform for Gemini CLI"
HOMEPAGE="https://github.com/josstei/maestro-orchestrate"
SRC_URI="https://github.com/josstei/maestro-orchestrate/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox test strip"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="net-libs/nodejs"

S="${WORKDIR}/maestro-orchestrate-${PV}"

src_compile() {
	einfo "Installing dependencies with bun..."
	bun install --ignore-scripts || die

	einfo "Generating artifacts..."
	bun run generate || die
}

src_install() {
	local module_dir="/usr/$(get_libdir)/node_modules/${PN}"
	insinto "${module_dir}"
	doins -r .

	# Binaries
	# bin/maestro-mcp-server.js
	# scripts/install-codex-plugin.js
	fperms +x "${module_dir}/bin/maestro-mcp-server.js"
	fperms +x "${module_dir}/scripts/install-codex-plugin.js"

	dosym "${module_dir}/bin/maestro-mcp-server.js" "/usr/bin/maestro-mcp-server"
	dosym "${module_dir}/scripts/install-codex-plugin.js" "/usr/bin/maestro-install-codex"

	einstalldocs
}
