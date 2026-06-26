# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, disk space efficient Node.js package manager (prebuilt binary)"
HOMEPAGE="https://pnpm.io"

SRC_URI="
	amd64? (
		static? (
			https://github.com/pnpm/pnpm/releases/download/v${PV}/pnpm-linuxstatic-x64   -> ${P}-amd64-static
		)
		!static? (
			https://github.com/pnpm/pnpm/releases/download/v${PV}/pnpm-linux-x64          -> ${P}-amd64-glibc
		)
	)
	arm64? (
		static? (
			https://github.com/pnpm/pnpm/releases/download/v${PV}/pnpm-linuxstatic-arm64 -> ${P}-arm64-static
		)
		!static? (
			https://github.com/pnpm/pnpm/releases/download/v${PV}/pnpm-linux-arm64        -> ${P}-arm64-glibc
		)
	)
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="static"
RESTRICT="strip mirror"

QA_PREBUILT="usr/bin/pnpm"

src_unpack() {
	:
}

src_compile() {
	:
}

src_install() {
	if use static ; then
		newbin "${DISTDIR}/${P}-${ARCH}-static" pnpm
	else
		newbin "${DISTDIR}/${P}-${ARCH}-glibc" pnpm
	fi
}
