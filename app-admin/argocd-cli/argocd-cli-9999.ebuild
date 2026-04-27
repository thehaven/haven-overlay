# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3

DESCRIPTION="CLI for Argo CD"
HOMEPAGE="https://github.com/argoproj/argo-cd"
EGIT_REPO_URI="https://github.com/argoproj/argo-cd.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

RESTRICT="network-sandbox"

src_compile() {
	ego build -ldflags "-s -w -X github.com/argoproj/argo-cd/v2/common.version=${PV}" -o argocd ./cmd/argocd
}

src_install() {
	dobin argocd
	dodoc README.md
}
