# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Local-first TUI/CLI for post-run agent session audits"
HOMEPAGE="https://github.com/luoyuctl/agenttrace"
SRC_URI="https://github.com/luoyuctl/agenttrace/releases/download/v${PV}/agenttrace-linux-amd64 -> ${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="usr/bin/agenttrace"
S="${WORKDIR}"

src_install() {
	newbin agenttrace-linux-amd64 agenttrace
}
