# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A simple, yet powerful CI/CD engine"
HOMEPAGE="https://woodpecker-ci.org"
SRC_URI="https://github.com/woodpecker-ci/woodpecker/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.22"

S="${WORKDIR}/woodpecker-${PV}"

src_compile() {
	ego build -o woodpecker-server ./cmd/server
	ego build -o woodpecker-agent ./cmd/agent
	ego build -o woodpecker-cli ./cmd/cli
}

src_install() {
	dobin woodpecker-server woodpecker-agent woodpecker-cli
}
