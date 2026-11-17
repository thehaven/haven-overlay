# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Automated semantic versioning and changelog generation"
HOMEPAGE="https://github.com/semantic-release/semantic-release"
SRC_URI="https://registry.npmjs.org/semantic-release/-/semantic-release-${PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=net-libs/nodejs-20[npm]"
RDEPEND="
	>=net-libs/nodejs-20
	!dev-python/python-semantic-release
"

src_compile() { :; }

src_install() {
	# npm install --global pulls the package AND its runtime deps from the
	# registry (network-sandbox opens network), replacing the former
	# MY_NODE_D mirror tarball and the FILESDIR wrapper script.
	npm install --global --prefix "${ED}/usr" "${DISTDIR}/${A}" || die
	einstalldocs
}
