# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unified AI rules management CLI tool"
HOMEPAGE="https://github.com/dyoshikawa/rulesync"
SRC_URI="https://github.com/dyoshikawa/rulesync/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox test strip"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="net-libs/nodejs"

S="${WORKDIR}/rulesync-${PV}"

src_compile() {
	einfo "Installing dependencies with bun..."
	bun install --ignore-scripts || die

	einfo "Building rulesync..."
	bun run build || die
}

src_install() {
	local module_dir="/usr/lib/node_modules/${PN}"
	insinto "${module_dir}"
	doins -r .

	# Binary is in dist/cli/index.js
	# Create a wrapper or symlink
	# We'll use a simple wrapper script
	mkdir -p "${D}/usr/bin" || die
	cat > "${D}/usr/bin/rulesync" <<EOF
#!/bin/sh
exec node "${module_dir}/dist/cli/index.js" "\$@"
EOF
	fperms +x /usr/bin/rulesync

	einstalldocs
}
