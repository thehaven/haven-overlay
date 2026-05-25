# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Moonlight colour theme for OpenCode"
HOMEPAGE="https://github.com/brunogabriel/opencode-moonlight-theme"
SRC_URI="https://github.com/brunogabriel/opencode-moonlight-theme/archive/d2266b691cbbe4ed177a168615f2eed0f508041b.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/opencode-moonlight-theme-d2266b691cbbe4ed177a168615f2eed0f508041b"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"
RDEPEND="dev-util/opencode"

src_compile() { :; }

src_install() {
	insinto /usr/share/opencode/themes
	doins .opencode/themes/moonlight.json
}
