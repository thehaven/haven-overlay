# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="${PN}-node_modules-${PV}"

DESCRIPTION="Automated semantic versioning and changelog generation"
HOMEPAGE="https://github.com/semantic-release/semantic-release"
SRC_URI="
	https://github.com/semantic-release/semantic-release/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=net-libs/nodejs-20"

S="${WORKDIR}/${PN}-${PV}"

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r lib package.json
	dobin "${FILESDIR}"/semantic-release
	einstalldocs
}
