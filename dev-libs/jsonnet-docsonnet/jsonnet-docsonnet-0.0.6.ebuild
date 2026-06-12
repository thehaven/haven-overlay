# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Jsonnet documentation helper library (doc-util)"
HOMEPAGE="https://github.com/jsonnet-libs/docsonnet"
SRC_URI="https://github.com/jsonnet-libs/docsonnet/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/docsonnet-${PV}/doc-util"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	insinto /usr/share/jsonnet-libs/docsonnet
	doins -r .
}
