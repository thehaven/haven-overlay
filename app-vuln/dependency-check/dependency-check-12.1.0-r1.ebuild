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
IUSE="cron +node +yarn +go"

RDEPEND="
	virtual/jre:1.8
	acct-user/dependency-check
	cron? ( virtual/cron )
	node? ( net-libs/nodejs )
	yarn? ( sys-apps/yarn )
	go? ( dev-lang/go )
"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/dependency-check"

src_install() {
	insinto /opt/${PN}
	doins -r .

	fperms +x /opt/${PN}/bin/dependency-check.sh

	# Create a wrapper that uses a user-writable data directory by default
	cat > "${T}/dependency-check" <<-EOF_WRAPPER
	#!/bin/bash
	# OWASP Dependency-Check Gentoo Wrapper
	DC_DATA_DIR="\${XDG_DATA_HOME:-\$HOME/.local/share}/dependency-check/data"
	mkdir -p "\$DC_DATA_DIR"
	exec /opt/dependency-check/bin/dependency-check.sh --data "\$DC_DATA_DIR" "\$@"
	EOF_WRAPPER

	dobin "${T}/dependency-check"

	if use cron; then
		insinto /etc/cron.daily
		newins "${FILESDIR}/dependency-check.cron" dependency-check
		fperms +x /etc/cron.daily/dependency-check
	fi

	keepdir /var/lib/dependency-check/data
	fowners dependency-check:dependency-check /var/lib/dependency-check/data
	fperms 0775 /var/lib/dependency-check/data
}

pkg_postinst() {
	elog "OWASP Dependency-Check has been installed with a user-writable data directory wrapper."
	elog "By default, data is stored in ~/.local/share/dependency-check/data"
	elog ""
	elog "NVD API KEY RECOMMENDATION:"
	elog "Modern versions of Dependency-Check use the NVD API which is rate-limited."
	elog "It is HIGHLY recommended to obtain an API key from:"
	elog "  https://nvd.nist.gov/developers/request-an-api-key"
	elog "And provide it via --nvdApiKey <key> or in your config."
	elog ""
	elog "To update the database manually:"
	elog "  dependency-check --updateonly"
	
	if use cron; then
		elog ""
		elog "Cron job installed at /etc/cron.daily/dependency-check"
		elog "It will update the shared database at /var/lib/dependency-check/data"
	fi
}
