# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OPA/Rego policy enforcement layer for AI coding agents"
HOMEPAGE="https://github.com/eqtylab/cupcake"
SRC_URI="https://github.com/eqtylab/cupcake/releases/download/v${PV}/cupcake-v${PV}-x86_64-unknown-linux-gnu.tar.gz -> ${P}-amd64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="usr/bin/cupcake"
S="${WORKDIR}"

src_install() {
	dobin cupcake
}
