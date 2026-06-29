# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="RTK — 60-90% terminal output compression for AI agents"
HOMEPAGE="https://github.com/rtk-ai/rtk"
SRC_URI="https://github.com/rtk-ai/rtk/releases/download/v${PV}/rtk-x86_64-unknown-linux-musl.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="usr/bin/rtk"
S="${WORKDIR}"

src_install() {
	dobin rtk
}
