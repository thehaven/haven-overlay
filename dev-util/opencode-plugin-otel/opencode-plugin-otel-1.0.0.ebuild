# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="opencode-plugin-otel-node_modules-1.0.0"

DESCRIPTION="OpenCode plugin for exporting telemetry via OpenTelemetry"
HOMEPAGE="https://github.com/DEVtheOPS/opencode-plugin-otel"
SRC_URI="
https://github.com/DEVtheOPS/opencode-plugin-otel/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/opencode-plugin-otel-${PV}"

src_compile() {
bun run build || die
}

src_install() {
insinto /usr/$(get_libdir)/node_modules/${PN}
doins -r dist package.json
}

pkg_postinst() {
einfo "opencode-plugin-otel installed."
}
