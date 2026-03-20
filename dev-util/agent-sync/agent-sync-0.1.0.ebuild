# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Deterministic, registry-agnostic synchronization of agent files"
HOMEPAGE="https://github.com/bianoble/agent-sync"
SRC_URI="https://github.com/bianoble/agent-sync/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.24"

src_compile() {
	ego build \
		-ldflags "-s -w \
			-X github.com/bianoble/agent-sync/cmd/agent-sync/cmd.version=${PV} \
			-X github.com/bianoble/agent-sync/cmd/agent-sync/cmd.commit=gentoo \
			-X github.com/bianoble/agent-sync/cmd/agent-sync/cmd.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
		-o agent-sync ./cmd/agent-sync
}

src_install() {
	dobin agent-sync
	einstalldocs
}
