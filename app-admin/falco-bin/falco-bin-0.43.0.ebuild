# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Cloud-native runtime security"
HOMEPAGE="https://falco.org"

BASE_URI="https://download.falco.org/packages/bin"
SRC_URI="
	amd64? ( ${BASE_URI}/x86_64/falco-${PV}-x86_64.tar.gz )
	arm64? ( ${BASE_URI}/aarch64/falco-${PV}-aarch64.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

QA_PREBUILT="*"
S="${WORKDIR}"

src_unpack() {
	default
	if use amd64; then
		S="${WORKDIR}/falco-${PV}-x86_64"
	else
		S="${WORKDIR}/falco-${PV}-aarch64"
	fi
}

src_install() {
	cd "${S}" || die
	dobin usr/bin/falco
	insinto /etc/falco
	doins -r etc/falco/*
}
