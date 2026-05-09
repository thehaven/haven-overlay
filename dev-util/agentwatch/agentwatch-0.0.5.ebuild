# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Local-only observability dashboard for AI coding agents"
HOMEPAGE="https://github.com/mishanefedov/agentwatch"
SRC_URI="https://github.com/mishanefedov/agentwatch/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox test strip"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )
	net-libs/nodejs"
RDEPEND="net-libs/nodejs"

S="${WORKDIR}/agentwatch-${PV}"

src_compile() {
	einfo "Installing dependencies with bun..."
	bun install --ignore-scripts || die

	einfo "Building agentwatch (Server + Web)..."
	bun run build || die
}

src_install() {
	# Install as a global node module
	local module_dir="/usr/lib/node_modules/${PN}"
	insinto "${module_dir}"
	doins -r .

	# Create symlink for the binary
	# bin/agentwatch.js is the entry point
	fperms +x "${module_dir}/bin/agentwatch.js"
	dosym "${module_dir}/bin/agentwatch.js" "/usr/bin/agentwatch"

	einstalldocs
}

pkg_postinst() {
	einfo "agentwatch installed. Run 'agentwatch' to start the TUI and dashboard."
}
