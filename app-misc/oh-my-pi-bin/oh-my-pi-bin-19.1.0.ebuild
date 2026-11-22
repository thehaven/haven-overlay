# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AI coding agent CLI with a terminal UI and session management"
HOMEPAGE="https://omp.sh https://github.com/can1357/oh-my-pi"
SRC_URI="
	amd64? ( https://github.com/can1357/oh-my-pi/releases/download/v${PV}/omp-linux-x64 -> omp-${PV}-linux-x64 )
	arm64? ( https://github.com/can1357/oh-my-pi/releases/download/v${PV}/omp-linux-arm64 -> omp-${PV}-linux-arm64 )
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
# mirror: each release asset is 220-275 MB; there is nothing to gain from
# mirroring them. strip: the payload is a Bun standalone executable, stripping
# it is not meaningful and can corrupt the embedded runtime blob.
RESTRICT="mirror strip"

RDEPEND="
	!app-misc/oh-my-pi
"

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
	einfo "oh-my-pi-bin installs the upstream prebuilt omp binary (${PV})."
	einfo ""
	einfo "Use app-misc/oh-my-pi instead if you want omp built from source"
	einfo "on this system; the two packages block each other."
	einfo ""
	einfo "See 'omp --help' for usage."
}
