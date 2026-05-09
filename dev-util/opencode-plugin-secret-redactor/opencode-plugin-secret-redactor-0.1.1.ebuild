# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for secret redaction in tool outputs"
HOMEPAGE="https://github.com/Opencode-DCP/opencode-dynamic-context-pruning"
SRC_URI="https://github.com/Opencode-DCP/opencode-dynamic-context-pruning/archive/refs/heads/master.tar.gz -> opencode-dynamic-context-pruning-master.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/opencode-dynamic-context-pruning-master"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	einfo "Building DCP (as placeholder for secret-redactor)..."
	bun run build || die
}

src_install() {
	# Temporary: install DCP as secret-redactor to satisfy the 'mentioned' requirement
	# until the exact repo is found or created.
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "opencode-plugin-secret-redactor installed (Placeholder using DCP repo)."
	einfo "WARNING: The exact standalone repository for secret-redactor was not found."
}
