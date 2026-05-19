# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Terminal security scanner for developers and AI agents"
HOMEPAGE="https://github.com/sheeki03/tirith"

BASE_URI="https://github.com/sheeki03/tirith/releases/download/v${PV}"
SRC_URI="
	amd64? ( ${BASE_URI}/tirith-x86_64-unknown-linux-gnu.tar.gz -> ${PN}-${PV}-amd64.tar.gz )
	arm64? ( ${BASE_URI}/tirith-aarch64-unknown-linux-gnu.tar.gz -> ${PN}-${PV}-arm64.tar.gz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

QA_PREBUILT="*"
S="${WORKDIR}"

src_install() {
	dobin tirith
	einstalldocs
}
