# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Comprehensive vulnerability scanner for containers and other artifacts"
HOMEPAGE="https://github.com/aquasecurity/trivy"
SRC_URI="https://github.com/aquasecurity/trivy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox"
IUSE="+cron"

RDEPEND="
	acct-user/trivy
	cron? ( virtual/cron )
"

src_compile() {
	export TMPDIR="${T}"
	export GOEXPERIMENT=jsonv2
	ego build -ldflags "-s -w -X github.com/aquasecurity/trivy/pkg/version.ver=${PV}" -o ${PN} ./cmd/trivy
}

src_install() {
	dobin ${PN}
	einstalldocs

	if use cron; then
		insinto /etc/cron.daily
		newins "${FILESDIR}/trivy.cron" trivy
		fperms +x /etc/cron.daily/trivy
	fi

	keepdir /var/lib/trivy/.cache/trivy
	fowners trivy:trivy /var/lib/trivy/.cache/trivy
	fperms 0775 /var/lib/trivy/.cache/trivy
}

pkg_postinst() {
	elog "Trivy has been installed."
	elog "Vulnerability databases are automatically updated on first run."
	
	if use cron; then
		elog ""
		elog "Cron job installed at /etc/cron.daily/trivy"
		elog "It will update the shared database at /var/lib/trivy/.cache/trivy"
	fi
}
