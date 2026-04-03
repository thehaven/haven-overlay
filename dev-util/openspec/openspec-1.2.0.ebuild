# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AI-native system for spec-driven development"
HOMEPAGE="https://github.com/Fission-AI/OpenSpec"
SRC_URI="https://github.com/Fission-AI/OpenSpec/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/OpenSpec-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="network-sandbox"

DEPEND="
	>=net-libs/nodejs-20
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=net-libs/nodejs-20
"

src_compile() {
	# Use pnpm via npx to install dependencies and build
	npx --yes pnpm install || die "pnpm install failed"
	npx --yes pnpm run build || die "pnpm build failed"
}

src_install() {
	local appdir="/opt/${PN}"
	dodir "${appdir}"
	
	# Copy built assets
	cp -r bin dist schemas scripts package.json package-lock.json pnpm-lock.yaml node_modules "${ED}${appdir}/" || die

	# Create a wrapper script in /usr/bin
	dodir /usr/bin
	cat <<-EOF > "${ED}/usr/bin/openspec" || die
		#!/bin/bash
		exec node "${appdir}/bin/openspec.js" "\$@"
	EOF
	fperms +x "/usr/bin/openspec"

	einstalldocs
}
