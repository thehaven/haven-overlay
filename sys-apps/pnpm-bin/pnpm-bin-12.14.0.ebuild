# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, disk space efficient Node.js package manager (prebuilt binary)"
HOMEPAGE="https://pnpm.io"

# Asset names resolved per version by metadata/bump-hooks/sys-apps/pnpm-bin
# (pnpm changed the asset naming between v10 and v12).
# pnpm dropped the statically linked linux build in v12, so there is no
# static variant to select any more and the glibc build is shipped only.
PNPM_GLIBC="pnpm-linux-x64.tar.gz"
PNPM_ARM64_GLIBC="pnpm-linux-arm64.tar.gz"

SRC_URI="
	amd64? (
		https://github.com/pnpm/pnpm/releases/download/v${PV}/${PNPM_GLIBC} -> ${P}-amd64-glibc
	)
	arm64? (
		https://github.com/pnpm/pnpm/releases/download/v${PV}/${PNPM_ARM64_GLIBC} -> ${P}-arm64-glibc
	)
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="strip mirror"

QA_PREBUILT="usr/bin/pnpm"

src_unpack() {
	:
}

src_compile() {
	:
}

src_install() {
	newbin "${DISTDIR}/${P}-${ARCH}-glibc" pnpm
}
