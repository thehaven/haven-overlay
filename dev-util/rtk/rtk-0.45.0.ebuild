# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="CLI proxy reducing LLM token consumption by 60-90% on dev commands"
HOMEPAGE="https://github.com/rtk-ai/rtk"

BASE_URI="https://github.com/rtk-ai/rtk/releases/download/v${PV}"
SRC_URI="
	amd64? ( ${BASE_URI}/rtk-x86_64-unknown-linux-musl.tar.gz -> ${PN}-${PV}-amd64.tar.gz )
	arm64? ( ${BASE_URI}/rtk-aarch64-unknown-linux-gnu.tar.gz -> ${PN}-${PV}-arm64.tar.gz )
"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

QA_PREBUILT="*"
RESTRICT="mirror"

src_install() {
	dobin rtk
	einstalldocs
}
