# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Superpowers: agentic skills framework for OpenCode and other AI harnesses"
HOMEPAGE="https://github.com/obra/superpowers"
SRC_URI="https://github.com/obra/superpowers/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/superpowers-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="dev-util/opencode"

src_install() {
	# Preserve the upstream repo layout: the OpenCode plugin resolves its
	# skills directory relative to the plugin file
	# (.opencode/plugins/superpowers.js -> ../../skills), so the whole tree
	# must be installed under one root. The plugin's config hook auto-registers
	# the skills dir — no symlinks or config edits needed beyond the plugin
	# entry in opencode.json.
	local libdir="$(get_libdir)"
	dodir "/usr/${libdir}/node_modules/${PN}"
	cp -R "${S}"/. "${D}/usr/${libdir}/node_modules/${PN}/" || die
}

pkg_postinst() {
	einfo "Superpowers installed to /usr/$(get_libdir)/node_modules/superpowers."
	einfo "To enable, add to the plugin array in opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/superpowers/.opencode/plugins/superpowers.js\""
	einfo "Restart OpenCode, then verify by asking: 'Tell me about your superpowers'"
}
