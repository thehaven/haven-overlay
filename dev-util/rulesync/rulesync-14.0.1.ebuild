# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unified AI rules management CLI tool"
HOMEPAGE="https://github.com/dyoshikawa/rulesync"
SRC_URI="https://github.com/dyoshikawa/rulesync/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/rulesync-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox test strip"

inherit bun

RDEPEND="net-libs/nodejs"

src_install() {
	local module_dir="/usr/$(get_libdir)/node_modules/${PN}"

	insinto "${module_dir}"
	doins -r .

	mkdir -p "${D}/usr/bin" || die
	cat > "${D}/usr/bin/rulesync" <<EOF
#!/bin/sh
exec node "${module_dir}/dist/cli/index.js" "\$@"
EOF
	fperms +x /usr/bin/rulesync

	einstalldocs
}
