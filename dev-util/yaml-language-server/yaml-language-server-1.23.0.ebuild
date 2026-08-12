# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="yaml-language-server"

DESCRIPTION="YAML language server"
HOMEPAGE="https://www.npmjs.com/package/yaml-language-server"
SRC_URI="https://registry.npmjs.org/${NPM_PKG}/-/${NPM_PKG}-${PV}.tgz"
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

	# Smoke test: verify the bin symlink exists and its target is executable
	# (catches the pre-bundled MY_NODE_D anti-pattern regression — npm's
	# global install resolves the 12 runtime deps itself)
	local bindir="${ED}/usr/bin"
	[[ -L "${bindir}/yaml-language-server" ]] || \
		die "npm install did not create /usr/bin/yaml-language-server"
	[[ -x $(realpath "${bindir}/yaml-language-server") ]] || \
		die "/usr/bin/yaml-language-server target is not executable"
}

pkg_postinst() {
	einfo "yaml-language-server ${PV}: LSP server for YAML — works with OpenCode"
	einfo "Binary: /usr/bin/yaml-language-server"
}
