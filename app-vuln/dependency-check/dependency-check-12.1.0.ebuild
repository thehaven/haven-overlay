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
	dosym ../../opt/${PN}/bin/dependency-check.sh /usr/bin/dependency-check
}

pkg_postinst() {
	elog "OWASP Dependency-Check has been installed to /opt/dependency-check"
	elog "Before first run, it will need to download the vulnerability database."
	elog "Run 'dependency-check --updateonly' to populate the database."
}
