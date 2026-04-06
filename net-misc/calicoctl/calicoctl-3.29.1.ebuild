# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

MY_PV="${PV/_/-}"
CALICO_COMMIT="ddfc3b1ea724e2580c68d34950f0ccd318ae3ebf"

DESCRIPTION="CLI to manage Calico network and security policy"
HOMEPAGE="https://github.com/projectcalico/calico"
SRC_URI="
	https://github.com/projectcalico/calico/archive/v${MY_PV}.tar.gz -> calico-${MY_PV}.tar.gz
	https://distfiles.haven-overlay.dev/${CATEGORY}/${PN}/${P}-deps.tar.xz
"
S="${WORKDIR}/calico-${MY_PV}"

LICENSE="Apache-2.0"
# Statically linked dependency licenses
LICENSE+=" BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

BDEPEND=">=dev-lang/go-1.22:="

src_compile() {
	local PACKAGE_NAME="github.com/projectcalico/calico/calicoctl"
	local go_ldflags=(
		-X "${PACKAGE_NAME}/calicoctl/commands.VERSION=${MY_PV}"
		-X "${PACKAGE_NAME}/calicoctl/commands.GIT_REVISION=${CALICO_COMMIT:0:7}"
		-X "${PACKAGE_NAME}/calicoctl/commands/common.VERSION=${MY_PV}"
		-X "main.VERSION=${MY_PV}"
		-s -w
	)
	CGO_ENABLED=0 ego build -trimpath \
		-ldflags "${go_ldflags[*]}" \
		-o bin/calicoctl \
		./calicoctl/calicoctl/calicoctl.go
}

src_install() {
	dobin bin/calicoctl
	dodoc calicoctl/README.md
}
