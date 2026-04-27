# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo

DESCRIPTION="Rust CLI to export Obsidian vaults to standard CommonMark"
HOMEPAGE="https://github.com/zoni/obsidian-export"
SRC_URI="https://github.com/zoni/obsidian-export/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# This tool is essential for CI/CD pipelines and static site generation (Quartz).
# Note: Requires network access during build for cargo dependencies.
RESTRICT="network-sandbox"

S="${WORKDIR}/obsidian-export-${PV}"

src_install() {
	cargo_src_install
}
