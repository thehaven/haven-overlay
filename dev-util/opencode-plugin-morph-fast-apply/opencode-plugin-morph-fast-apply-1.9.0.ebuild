# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="${PN}-node_modules-${PV}"
DESCRIPTION="Integrates Morph's Fast Apply API for 10,500+ tokens/sec code editing"
HOMEPAGE="https://github.com/JRedeker/opencode-morph-fast-apply"
SRC_URI="
	https://github.com/JRedeker/opencode-morph-fast-apply/archive/0625507c07ac73443ec8780a674778287a4a0c4e.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"
S="${WORKDIR}/opencode-morph-fast-apply-1.9.0"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"

src_compile() {
	einfo "Source-only plugin. No build required."
}

src_install() {
	local libdir=$(get_libdir)
	local module_dir="/usr/${libdir}/node_modules/${PN}"
	
	insinto "${module_dir}"
	# Install everything in the root
	doins -r .
	
	einfo "Installing vendor node_modules..."
	mkdir -p "${ED}/${module_dir}" || die
	cp -a "${WORKDIR}/node_modules" "${ED}/${module_dir}/" || die
}

pkg_postinst() {
	einfo "opencode-plugin-morph-fast-apply installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  { \"name\": \"${PN}\", \"src\": \"/usr/lib/node_modules/${PN}/index.ts\" }"
}
