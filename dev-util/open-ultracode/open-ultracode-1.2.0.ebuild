# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Multi-agent ultra-high-effort coding extension for OpenCode"
HOMEPAGE="https://github.com/norandom/OpenUltraCode"
SRC_URI="https://github.com/norandom/OpenUltraCode/releases/download/v${PV}/open-ultracode-release.tar.gz -> ${P}-release.tar.gz"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="dev-util/opencode"

src_install() {
	insinto /usr/share/opencode/plugins/${PN}
	doins -r .opencode docs src package.json README.md
}

pkg_postinst() {
	einfo "OpenUltraCode installed to /usr/share/opencode/plugins/${PN}/"
	einfo "To activate, symlink the .opencode directory into your project:"
	einfo "  ln -s /usr/share/opencode/plugins/${PN}/.opencode .opencode"
	einfo "Or reference it from your opencode config."
}
