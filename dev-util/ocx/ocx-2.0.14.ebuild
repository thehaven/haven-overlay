# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode package manager"
HOMEPAGE="https://github.com/kdcokenny/ocx"
SRC_URI="https://github.com/kdcokenny/ocx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/ocx-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="network-sandbox test"

inherit bun

RDEPEND="dev-util/opencode"

src_install() {
	local module_dir="/usr/$(get_libdir)/node_modules/${PN}"

	insinto "${module_dir}"
	doins -r packages/cli/dist packages/cli/package.json

	dosym "../$(get_libdir)/node_modules/${PN}/packages/cli/dist/index.js" /usr/bin/ocx
	fperms +x "${module_dir}/packages/cli/dist/index.js"

	dodoc README.md
}

pkg_postinst() {
	einfo "ocx installed. Run ocx --help to get started."
}
