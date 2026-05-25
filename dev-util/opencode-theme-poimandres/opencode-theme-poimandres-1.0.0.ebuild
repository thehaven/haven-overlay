# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Poimandres theme for OpenCode"
HOMEPAGE="https://github.com/ajaxdude/opencode-ai-poimandres-theme"
SRC_URI="https://github.com/ajaxdude/opencode-ai-poimandres-theme/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/opencode-ai-poimandres-theme-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

RDEPEND="dev-util/opencode"

src_compile() { :; }

src_install() {
	insinto /usr/share/opencode/themes
	doins .opencode/themes/poimandres.json
}
