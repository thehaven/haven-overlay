# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Oh My Pi: Agentic hardware hacking assistant"
HOMEPAGE="https://github.com/can1357/oh-my-pi"
SRC_URI="
	amd64? ( https://github.com/can1357/oh-my-pi/releases/download/v${PV}/omp-linux-x64 -> omp-${PV}-linux-x64 )
	arm64? ( https://github.com/can1357/oh-my-pi/releases/download/v${PV}/omp-linux-arm64 -> omp-${PV}-linux-arm64 )
"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

QA_PREBUILT="*"

src_unpack() {
	local distfile
	if use amd64; then
		distfile="omp-${PV}-linux-x64"
	elif use arm64; then
		distfile="omp-${PV}-linux-arm64"
	fi
	cp "${DISTDIR}/${distfile}" "${S}/" || die
}

src_install() {
	if use amd64; then
		newbin omp-${PV}-linux-x64 omp
	elif use arm64; then
		newbin omp-${PV}-linux-arm64 omp
	fi
}

pkg_postinst() {
	einfo "Oh My Pi provides agentic hardware hacking assistance."
	einfo "Usage: omp --help"
}
