# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3

DESCRIPTION="CLI for Argo Rollouts"
HOMEPAGE="https://github.com/argoproj/argo-rollouts"
EGIT_REPO_URI="https://github.com/argoproj/argo-rollouts.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

RESTRICT="network-sandbox"

src_prepare() {
	default
	# Patch go version in go.mod to match system go
	sed -i 's/^go .*/go 1.25.5/' go.mod || die
}

src_compile() {
	ego build -ldflags "-s -w -X github.com/argoproj/argo-rollouts/pkg/version.version=${PV}" -o kubectl-argo-rollouts ./cmd/kubectl-argo-rollouts
}

src_install() {
	newbin kubectl-argo-rollouts kubectl-argo-rollouts
	dodoc README.md
}
