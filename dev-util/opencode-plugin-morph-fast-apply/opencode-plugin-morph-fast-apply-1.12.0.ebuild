# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bun

DESCRIPTION="Integrates Morph's Fast Apply API for 10,500+ tokens/sec code editing"
HOMEPAGE="https://github.com/JRedeker/opencode-morph-fast-apply"
# Upstream ships a git tag per release; the archive directory GitHub creates for a
# tag is <repo>-<version without the leading v>, so S follows ${PV}.
SRC_URI="https://github.com/JRedeker/opencode-morph-fast-apply/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/opencode-morph-fast-apply-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox test strip"

src_compile() {
	# Source-only plugin: install deps (replaces the MY_NODE_D tarball),
	# no build step required.
	rm -f package-lock.json
	bun install --ignore-scripts || die "bun install failed"
}

src_install() {
	local libdir=$(get_libdir)
	local module_dir="/usr/${libdir}/node_modules/${PN}"

	insinto "${module_dir}"
	# Everything in the root, including bun-installed node_modules
	doins -r .
}

pkg_postinst() {
	einfo "opencode-plugin-morph-fast-apply installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  { \"name\": \"${PN}\", \"src\": \"/usr/$(get_libdir)/node_modules/${PN}/index.ts\" }"
}
