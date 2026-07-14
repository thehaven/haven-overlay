# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Local-only observability dashboard for AI coding agents"
HOMEPAGE="https://github.com/mishanefedov/agentwatch"
SRC_URI="https://github.com/mishanefedov/agentwatch/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/agentwatch-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox test strip"

inherit bun

BDEPEND="net-libs/nodejs"
RDEPEND="net-libs/nodejs"

src_install() {
	local module_dir="/usr/$(get_libdir)/node_modules/${PN}"

	insinto "${module_dir}"
	doins -r .

	fperms +x "${module_dir}/bin/agentwatch.js"
	dosym "${module_dir}/bin/agentwatch.js" /usr/bin/agentwatch

	einstalldocs
}

pkg_postinst() {
	einfo "agentwatch installed. Run agentwatch to start the TUI and dashboard."
}
