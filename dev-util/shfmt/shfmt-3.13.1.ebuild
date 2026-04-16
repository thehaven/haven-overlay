# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A shell formatter supporting POSIX shell, bash, and mksh"
HOMEPAGE="https://github.com/mvdan/sh"

BASE_URI="https://github.com/mvdan/sh/releases/download/v${PV}"
SRC_URI="
	amd64? ( ${BASE_URI}/shfmt_v${PV}_linux_amd64 -> ${P}-linux-amd64 )
	arm64? ( ${BASE_URI}/shfmt_v${PV}_linux_arm64 -> ${P}-linux-arm64 )
"

S="${WORKDIR}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror strip"

QA_PREBUILT="usr/bin/shfmt"

src_unpack() {
	local src
	case ${ARCH} in
		amd64) src="${DISTDIR}/${P}-linux-amd64" ;;
		arm64) src="${DISTDIR}/${P}-linux-arm64" ;;
		*) die "Unsupported architecture: ${ARCH}" ;;
	esac
	cp "${src}" "${WORKDIR}/shfmt" || die
	chmod +x "${WORKDIR}/shfmt" || die
}

src_install() {
	dobin shfmt
}

pkg_postinst() {
	einfo "shfmt ${PV} installed."
	einfo "opencode will auto-detect shfmt and use it to format .sh/.bash files."
	einfo "See: https://github.com/mvdan/sh"
}
