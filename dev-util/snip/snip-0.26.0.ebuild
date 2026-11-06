# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="CLI proxy that reduces LLM token usage by 60-90%"
HOMEPAGE="https://github.com/edouard-claude/snip"
SRC_URI="https://github.com/edouard-claude/snip/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

src_unpack() {
	default
}

src_compile() {
	# Hack go.mod to match system Go
	sed -i 's/go 1.25.8/go 1.25.5/' go.mod || die
	ego build -o ${PN} ./cmd/${PN}
}

src_install() {
	dobin ${PN}
	einstalldocs
}
