# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, disk space efficient Node.js package manager (prebuilt binary)"
HOMEPAGE="https://pnpm.io"

# Asset names resolved per version by metadata/bump-hooks/sys-apps/pnpm-bin
# (pnpm changed naming between v10 and v12; the static variant was dropped
# in v12 — drop the static USE flag at bump time).
PNPM_STATIC="pnpm-linuxstatic-x64"
PNPM_GLIBC="pnpm-linux-x64"
PNPM_MUSL=""
PNPM_ARM64_STATIC="pnpm-linuxstatic-arm64"
PNPM_ARM64_GLIBC="pnpm-linux-arm64"

SRC_URI="
	amd64? (
		static? (
			https://github.com/pnpm/pnpm/releases/download/v${PV}/${PNPM_STATIC}   -> ${P}-amd64-static
		)
		!static? (
			https://github.com/pnpm/pnpm/releases/download/v${PV}/${PNPM_GLIBC}    -> ${P}-amd64-glibc
		)
	)
	arm64? (
		static? (
			https://github.com/pnpm/pnpm/releases/download/v${PV}/${PNPM_ARM64_STATIC} -> ${P}-arm64-static
		)
		!static? (
			https://github.com/pnpm/pnpm/releases/download/v${PV}/${PNPM_ARM64_GLIBC}  -> ${P}-arm64-glibc
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
