# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Fast container image distribution plugin for containerd"
HOMEPAGE="https://github.com/containerd/stargz-snapshotter"
SRC_URI="https://github.com/containerd/stargz-snapshotter/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.22"

S="${WORKDIR}/stargz-snapshotter-${PV}"

src_compile() {
	ego build -o containerd-stargz-grpc ./cmd/containerd-stargz-grpc
	ego build -o ctr-remote ./cmd/ctr-remote
}

src_install() {
	dobin containerd-stargz-grpc ctr-remote
}
