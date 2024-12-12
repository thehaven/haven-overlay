# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-vcs-snapshot

CALICOCTL_COMMIT="ddfc3b1ea724e2580c68d34950f0ccd318ae3ebf"
PACKAGE_NAME='github.com/projectcalico/calico/calicoctl'

KEYWORDS="~amd64"
DESCRIPTION="CLI to manage Calico network and security policy"
EGO_PN="github.com/projectcalico/calico"
HOMEPAGE="https://github.com/projectcalico/calico"
MY_PV=${PV/_/-}
SRC_URI="https://${EGO_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test network-sandbox"

src_compile() {
	pushd "src/${EGO_PN}/calicoctl" || die
	GOPATH="${WORKDIR}/${P}" CGO_ENABLED=0 go build -v -o dist/calicoctl -ldflags \
		"-X ${PACKAGE_NAME}/calicoctl/commands.VERSION=${MY_PV} \
		-X ${PACKAGE_NAME}/calicoctl/commands..BUILD_DATE=$(date -u +'%FT%T%z') \
		-X ${PACKAGE_NAME}/calicoctl/commands.GIT_REVISION=${CALICOCTL_COMMIT} \
		-X ${PACKAGE_NAME}/calicoctl/commands/common.VERSION=${MY_PV} \
		-X main.VERSION=${MY_PV} -s -w" "./calicoctl/calicoctl.go" || die
	popd || die
}

src_install() {
	pushd "src/${EGO_PN}/calicoctl" || die
	dobin "dist/${PN}"
	dodoc README.md
}
