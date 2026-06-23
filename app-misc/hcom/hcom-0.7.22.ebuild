# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Cross-terminal agent communication — message, watch, and spawn AI agents"
HOMEPAGE="https://github.com/aannoo/hcom"
SRC_URI="https://github.com/aannoo/hcom/releases/download/v${PV}/hcom-x86_64-unknown-linux-gnu.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="usr/bin/hcom"
S="${WORKDIR}"

src_install() {
	dobin hcom
}
