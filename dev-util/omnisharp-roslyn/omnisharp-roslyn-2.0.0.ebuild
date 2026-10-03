# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OmniSharp server based on Roslyn workspaces"
HOMEPAGE="https://github.com/OmniSharp/omnisharp-roslyn"
SRC_URI="
	amd64? ( https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${PV}/omnisharp-linux-x64-net6.0.tar.gz -> ${P}-amd64.tar.gz )
	arm64? ( https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${PV}/omnisharp-linux-arm64-net6.0.tar.gz -> ${P}-arm64.tar.gz )
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="mirror strip"

QA_PREBUILT="usr/share/omnisharp/*"

RDEPEND="virtual/dotnet-sdk"

src_unpack() {
	mkdir -p "${S}/omnisharp" || die
	if use amd64; then
		tar -xzf "${DISTDIR}/${P}-amd64.tar.gz" -C "${S}/omnisharp" || die
	elif use arm64; then
		tar -xzf "${DISTDIR}/${P}-arm64.tar.gz" -C "${S}/omnisharp" || die
	fi
}

src_install() {
	insinto /usr/share/omnisharp
	doins -r "${S}/omnisharp"/*
	fperms +x /usr/share/omnisharp/OmniSharp

	dodir /usr/bin
	cat <<-EOF > "${ED}/usr/bin/omnisharp-roslyn" || die
		#!/bin/sh
		exec /usr/share/omnisharp/OmniSharp "\$@"
	EOF
	fperms +x /usr/bin/omnisharp-roslyn
	dosym omnisharp-roslyn /usr/bin/omnisharp
}

pkg_postinst() {
	einfo "omnisharp-roslyn ${PV}: C# LSP server — works with OpenCode"
	einfo "Binary: /usr/bin/omnisharp-roslyn (and /usr/bin/omnisharp)"
}
