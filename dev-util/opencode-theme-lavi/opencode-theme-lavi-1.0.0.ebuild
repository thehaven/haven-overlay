# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Lavi — soft sweet colour scheme for OpenCode and 15+ apps"
HOMEPAGE="https://github.com/b0o/lavi"
SRC_URI="https://github.com/b0o/lavi/archive/1db679a05896e060849f424eec40c0d904bef2d1.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/lavi-1db679a05896e060849f424eec40c0d904bef2d1"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"
RDEPEND="dev-util/opencode"

src_compile() { :; }

src_install() {
	insinto /usr/share/opencode/themes
	doins contrib/opencode/lavi.json
}
