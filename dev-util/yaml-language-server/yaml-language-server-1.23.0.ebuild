# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="${PN}-node_modules-${PV}"
NPM_MODULE="yaml-language-server"
inherit npm

DESCRIPTION="YAML language server"
HOMEPAGE="https://www.npmjs.com/package/yaml-language-server"
SRC_URI+=" https://gitlab-ee.thehavennet.org.uk/haven/gentoo-distfiles/-/raw/main/${MY_NODE_D}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="net-libs/nodejs"

src_unpack() {
	unpack ${A}
	if [[ -d "${WORKDIR}/package" ]]; then
		mv "${WORKDIR}/package" "${S}" || die
	fi
}

src_test() {
	einfo "Testing yaml-language-server LSP startup"
	timeout 5 node "${S}/bin/yaml-language-server" --stdio < /dev/null 2>&1 &
	local pid=$!
	sleep 2
	kill "${pid}" 2>/dev/null || true
	wait "${pid}" 2>/dev/null
}

src_install() {
	npm_src_install
	local mod_dir="/usr/$(get_libdir)/node_modules/${NPM_MODULE}"
	if [[ -d "${WORKDIR}/node_modules" ]]; then
		insinto "${mod_dir}"
		doins -r "${WORKDIR}/node_modules"
	fi
	npm_install_bin bin/yaml-language-server
}

pkg_postinst() {
	einfo "yaml-language-server ${PV}: LSP server for YAML — works with OpenCode"
	einfo "Binary: /usr/bin/yaml-language-server"
}
