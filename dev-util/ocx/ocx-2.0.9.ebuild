# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode package manager"
HOMEPAGE="https://github.com/kdcokenny/ocx"
SRC_URI="https://github.com/kdcokenny/ocx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/ocx-${PV}"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	einfo "Building all packages..."
	bun run build || die
}

src_install() {
	# Install CLI
	insinto /usr/$(get_libdir)/node_modules/ocx
	doins -r packages/cli/dist packages/cli/package.json
	
	# Install Registry worker (optional but useful if Haven wants to run local registry)
	# insinto /usr/$(get_libdir)/node_modules/ocx-worker
	# doins -r packages/worker/dist packages/worker/package.json

	# Create binary symlink
	dosym "../$(get_libdir)/node_modules/ocx/dist/index.js" /usr/bin/ocx
	fperms +x /usr/$(get_libdir)/node_modules/ocx/dist/index.js
	
	dodoc README.md
}

pkg_postinst() {
	einfo "ocx installed. Run 'ocx --help' to get started."
}
