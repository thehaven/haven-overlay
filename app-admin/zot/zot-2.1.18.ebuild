# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="OCI-native container image registry"
HOMEPAGE="https://zotregistry.dev"
SRC_URI="https://github.com/project-zot/zot/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.22"

S="${WORKDIR}/zot-${PV}"

src_compile() {
	ego build -ldflags "-s -w -X github.com/project-zot/zot/pkg/api/config.ReleaseVersion=v${PV}" -o zot ./cmd/zot
}

src_install() {
	dobin zot
	dodoc README.md
}
