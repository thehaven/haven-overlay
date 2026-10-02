# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="dockerfile-language-server-nodejs"

DESCRIPTION="A language server for Dockerfiles powered by NodeJS"
HOMEPAGE="https://github.com/rcjsuen/dockerfile-language-server-nodejs"
SRC_URI="https://registry.npmjs.org/${NPM_PKG}/-/${NPM_PKG}-${PV}.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND="net-libs/nodejs"

src_compile() { :; }

src_install() {
	npm install --audit false --global --omit dev \
		--prefix "${ED}/usr" "${DISTDIR}/${P}.tgz" || die

	local bindir="${ED}/usr/bin"
	[[ -L "${bindir}/docker-langserver" ]] || \
		die "npm install did not create /usr/bin/docker-langserver"
	[[ -x $(realpath "${bindir}/docker-langserver") ]] || \
		die "/usr/bin/docker-langserver target is not executable"
}

pkg_postinst() {
	einfo "docker-langserver ${PV}: LSP server for Dockerfiles — works with OpenCode"
	einfo "Binary: /usr/bin/docker-langserver"
}
