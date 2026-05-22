# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="SCA tool that identifies project dependencies and vulnerabilities"
HOMEPAGE="https://owasp.org/www-project-dependency-check/"
SRC_URI="https://github.com/jeremylong/DependencyCheck/releases/download/v${PV}/dependency-check-${PV}-release.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="virtual/jre:1.8"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/dependency-check"

src_install() {
	insinto /opt/${PN}
	doins -r .

	fperms +x /opt/${PN}/bin/dependency-check.sh

	# Create a wrapper that uses a user-writable data directory by default
	cat > "${T}/dependency-check" <<-EOF
	#!/bin/bash
	# OWASP Dependency-Check Gentoo Wrapper
	DC_DATA_DIR="\${XDG_DATA_HOME:-\$HOME/.local/share}/dependency-check/data"
	mkdir -p "\$DC_DATA_DIR"
	exec /opt/dependency-check/bin/dependency-check.sh --data "\$DC_DATA_DIR" "\$@"
	EOF

	dobin "${T}/dependency-check"
}

pkg_postinst() {
	elog "OWASP Dependency-Check has been installed with a user-writable data directory wrapper."
	elog "By default, data is stored in ~/.local/share/dependency-check/data"
	elog "Before first run, you should update the database:"
	elog "  dependency-check --updateonly"
}
