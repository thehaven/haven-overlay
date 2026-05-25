# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Ayu Dark colour scheme for OpenCode"
HOMEPAGE="https://github.com/postrednik/opencode-ayu-theme"
SRC_URI="https://github.com/postrednik/opencode-ayu-theme/archive/71c2a8b2fd0adcc59c0db3c5e793213a8bd54ccc.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/opencode-ayu-theme-71c2a8b2fd0adcc59c0db3c5e793213a8bd54ccc"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"
RDEPEND="dev-util/opencode"

src_compile() { :; }

src_install() {
	insinto /usr/share/opencode/themes
	doins .opencode/themes/ayu-dark.json
}
