# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3

DESCRIPTION="CLI for Argo Workflows"
HOMEPAGE="https://github.com/argoproj/argo-workflows"
EGIT_REPO_URI="https://github.com/argoproj/argo-workflows.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

RESTRICT="network-sandbox"

src_compile() {
	ego build -ldflags "-s -w -X github.com/argoproj/argo-workflows/v3/common.version=${PV}" -o argo ./cmd/argo
}

src_install() {
	dobin argo
	dodoc README.md
}
