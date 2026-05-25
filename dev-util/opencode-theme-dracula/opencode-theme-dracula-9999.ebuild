# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dracula theme for OpenCode"
HOMEPAGE="https://github.com/dracula/opencode"
inherit git-r3
EGIT_REPO_URI="https://github.com/dracula/opencode.git"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RESTRICT="network-sandbox"

RDEPEND="dev-util/opencode"

src_compile() { :; }

src_install() {
	insinto /usr/share/opencode/themes
	doins dracula.json
}
