# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="SpecStory — local-first AI conversation capture CLI for terminal agents"
HOMEPAGE="https://specstory.com"
SRC_URI="https://github.com/specstoryai/getspecstory/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

# Upstream repo is getspecstory; extracts to getspecstory-${PV}/; CLI in specstory-cli/
S="${WORKDIR}/getspecstory-${PV}/specstory-cli"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND=">=dev-lang/go-1.26.0"

# go mod verify during unpack requires network access
RESTRICT="network-sandbox"

src_compile() {
	# Match upstream goreleaser: static binary, stripped, CGO disabled
	CGO_ENABLED=0 ego build \
		-ldflags "-s -w -X main.version=${PV}" \
		-o specstory \
		. || die
}

src_install() {
	dobin specstory
	einstalldocs
}
