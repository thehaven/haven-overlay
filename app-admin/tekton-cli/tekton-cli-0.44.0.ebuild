# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="CLI for Tekton Pipelines"
HOMEPAGE="https://tekton.dev"
SRC_URI="https://github.com/tektoncd/cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.22"

S="${WORKDIR}/cli-${PV}"

src_compile() {
	ego build -o tkn ./cmd/tkn
}

src_install() {
	dobin tkn
}
