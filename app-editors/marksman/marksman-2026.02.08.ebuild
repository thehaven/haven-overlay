# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_TAG="2026-02-08"
DESCRIPTION="Markdown LSP server providing completion, references, symbols, and diagnostics"
HOMEPAGE="https://github.com/artempyanykh/marksman"
SRC_URI="
	amd64? ( https://github.com/artempyanykh/marksman/releases/download/${MY_TAG}/marksman-linux-x64 -> ${P}-amd64 )
	arm64? ( https://github.com/artempyanykh/marksman/releases/download/${MY_TAG}/marksman-linux-arm64 -> ${P}-arm64 )
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="mirror strip"

QA_PREBUILT="usr/bin/marksman"

src_unpack() {
	if use amd64; then
		cp "${DISTDIR}/${P}-amd64" "${WORKDIR}/marksman" || die
	elif use arm64; then
		cp "${DISTDIR}/${P}-arm64" "${WORKDIR}/marksman" || die
	fi
}

src_install() {
	dobin marksman
}

pkg_postinst() {
	einfo "Marksman is a Markdown LSP server."
	einfo ""
	einfo "Editor setup examples:"
	einfo "  Neovim (lspconfig):"
	einfo "    require('lspconfig').marksman.setup{}"
	einfo "  Helix: add 'marksman' to language-server config"
	einfo "  Emacs (eglot): ensure marksman is in PATH"
}
