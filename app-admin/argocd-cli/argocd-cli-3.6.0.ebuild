# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="CLI for Argo CD"
HOMEPAGE="https://argoproj.github.io/argo-cd"
SRC_URI="https://github.com/argoproj/argo-cd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.22"

S="${WORKDIR}/argo-cd-${PV}"

src_compile() {
	ego build -o argocd ./cmd/argocd
}

src_install() {
	dobin argocd
}
