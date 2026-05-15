# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Model Context Protocol server for PostgreSQL"
HOMEPAGE="https://github.com/modelcontextprotocol/servers"
SRC_URI="https://registry.npmjs.org/@modelcontextprotocol/server-postgres/-/server-postgres-${PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

BDEPEND=">=net-libs/nodejs-20[npm]"
RDEPEND=">=net-libs/nodejs-20 dev-db/postgresql"

src_compile() { :; }

src_install() {
	npm install --global --prefix "${ED}/usr" "${DISTDIR}/${A}" || die
	einstalldocs
}

pkg_postinst() {
	einfo "mcp-postgres installed."
}
