# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="CLI for Argo Workflows"
HOMEPAGE="https://argoproj.github.io/argo-workflows"
SRC_URI="https://github.com/argoproj/argo-workflows/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.22"

S="${WORKDIR}/argo-workflows-${PV}"

src_compile() {
	ego build -o argo ./cmd/argo
}

src_install() {
	dobin argo
}
