# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Docker LSP server for Dockerfiles, Compose, and Bake files"
HOMEPAGE="https://github.com/docker/docker-language-server"
SRC_URI="
	amd64? ( https://github.com/docker/docker-language-server/releases/download/v${PV}/docker-language-server-linux-amd64-v${PV} -> ${P}-amd64 )
	arm64? ( https://github.com/docker/docker-language-server/releases/download/v${PV}/docker-language-server-linux-arm64-v${PV} -> ${P}-arm64 )
"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="mirror strip"

QA_PREBUILT="usr/bin/docker-language-server"

src_unpack() {
	if use amd64; then
		cp "${DISTDIR}/${P}-amd64" "${WORKDIR}/docker-language-server" || die
	elif use arm64; then
		cp "${DISTDIR}/${P}-arm64" "${WORKDIR}/docker-language-server" || die
	fi
}

src_install() {
	dobin docker-language-server
}

pkg_postinst() {
	einfo "Docker Language Server for Dockerfiles, Compose, and Bake files."
	einfo ""
	einfo "Editor setup: configure your LSP client to use 'docker-language-server'"
	einfo "Neovim (lspconfig):"
	einfo "  require('lspconfig').dockerls.setup{}"
	einfo ""
	einfo "Full features require 'docker buildx' plugin installed."
}
