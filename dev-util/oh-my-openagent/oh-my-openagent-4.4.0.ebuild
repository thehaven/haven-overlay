# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="oh-my-openagent-node_modules-4.4.0"

DESCRIPTION="omo; the best agent harness for OpenCode"
HOMEPAGE="https://github.com/code-yeongyu/oh-my-openagent"
SRC_URI="
	https://github.com/code-yeongyu/oh-my-openagent/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/oh-my-openagent-${PV}"

src_compile() {
	bun run build || die
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "oh-my-openagent installed."
}
