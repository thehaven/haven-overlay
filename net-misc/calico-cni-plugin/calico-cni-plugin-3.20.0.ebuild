# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-vcs-snapshot

KEYWORDS="~amd64"
DESCRIPTION="Calico Networking for CNI"
EGO_PN="github.com/projectcalico/cni-plugin"
HOMEPAGE="https://github.com/projectcalico/cni-plugin"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-go/glide
		>=dev-lang/go-1.7"
RDEPEND="net-misc/cni-plugins"
RESTRICT="network-sandbox collision-detect protect-owned"

src_compile() {
	pushd src/${EGO_PN} || die
	make build
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	exeinto /opt/cni/bin
	doexe bin/${ARCH}/*
	dodoc README.md
	popd || die
}
