# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-vcs-snapshot

CALICOCTL_COMMIT="0e555ea2ccc9c2cb5030eab2b43abe97a534f17f"

KEYWORDS="~amd64"
DESCRIPTION="CLI to manage Calico network and security policy"
EGO_PN="github.com/projectcalico/calicoctl"
HOMEPAGE="https://github.com/projectcalico/calicoctl"
MY_PV=${PV/_/-}
SRC_URI="https://${EGO_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test network-sandbox"

src_compile() {
	pushd "src/${EGO_PN}" || die
	GOPATH="${WORKDIR}/${P}" CGO_ENABLED=0 go build -v -o dist/calicoctl -ldflags \
		"-X github.com/projectcalico/calicoctl/v3/calicoctl/commands.VERSION=${MY_PV} \
		-X github.com/projectcalico/calicoctl/v3/calicoctl/commands..BUILD_DATE=$(date -u +'%FT%T%z') \
		-X github.com/projectcalico/calicoctl/v3/calicoctl/commands.GIT_REVISION=${CALICOCTL_COMMIT} \
		-X github.com/projectcalico/calicoctl/v3/calicoctl/commands/common.VERSION=${MY_PV} -s -w" "./calicoctl/calicoctl.go" || die
	popd || die
}

src_install() {
	pushd "src/${EGO_PN}" || die
	dobin "dist/${PN}"
	dodoc README.md
}
