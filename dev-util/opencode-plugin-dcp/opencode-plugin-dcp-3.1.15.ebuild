# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for dynamic context pruning"
HOMEPAGE="https://github.com/Tarquinen/opencode-dynamic-context-pruning"
SRC_URI="https://registry.npmjs.org/@tarquinen/opencode-dcp/-/opencode-dcp-${PV}.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND="net-libs/nodejs"

src_compile() { :; }

src_install() {
	npm install --audit false --global --omit dev \
		--prefix "${ED}/usr" "${DISTDIR}/${P}.tgz" || die
}
