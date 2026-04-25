# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Core service for Project Harbor"
HOMEPAGE="https://github.com/goharbor/harbor"
SRC_URI="https://github.com/goharbor/harbor/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Harbor core requires network-sandbox restriction if no vendor tarball provided
RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.22"

S="${WORKDIR}/harbor-${PV}"

src_compile() {
	ego build -ldflags "-s -w -X github.com/goharbor/harbor/src/pkg/version.ReleaseVersion=v${PV}" -o harbor_core ./src/core
}

src_install() {
	dobin harbor_core
	dodoc README.md
}
