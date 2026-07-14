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

S="${WORKDIR}/opencode-plugin-otel-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

inherit bun

RDEPEND="dev-util/opencode"

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json
}
