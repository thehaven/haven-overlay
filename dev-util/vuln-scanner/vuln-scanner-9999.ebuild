# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 git-r3

DESCRIPTION="Unified security scanner orchestrator for Gentoo"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/gentoo/vuln-scanner"
EGIT_REPO_URI="/storage/home/haven/projects/vuln-scanner"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+cron +pdf +trivy +grype +depcheck"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/apprise[${PYTHON_USEDEP}]
	trivy? ( app-vuln/trivy )
	grype? ( app-vuln/grype )
	depcheck? ( app-vuln/dependency-check )
	cron? ( virtual/cron )
	pdf? ( app-text/pandoc-bin )
"

src_install() {
	distutils-r1_src_install

	# Install config example
	insinto /etc/${PN}
	doins config.toml.example

	# Install default templates
	insinto /usr/share/${PN}/templates
	doins templates/*.j2 templates/*.css

	# Create template override directory
	keepdir /etc/${PN}/templates

	# Install cron jobs
	if use cron; then
		for freq in daily weekly monthly; do
			(
				insinto "/etc/cron.${freq}"
				newins "${FILESDIR}/${PN}.cron" "${PN}"
				fperms +x "/etc/cron.${freq}/${PN}"
				sed -i "s/{{FREQ}}/${freq}/g" "${D}/etc/cron.${freq}/${PN}" || die
			)
		done
	fi

	keepdir /var/log/security-scans
	fperms 0770 /var/log/security-scans
}

pkg_postinst() {
	elog "vuln-scanner has been installed."
	elog ""
	elog "CONFIGURATION:"
	elog "Please create /etc/vuln-scanner/config.toml based on the example:"
	elog "  /etc/vuln-scanner/config.toml.example"
	elog ""
	elog "TEMPLATES:"
	elog "Default templates are in /usr/share/vuln-scanner/templates/"
	elog "You can override them by placing modified versions in:"
	elog "  /etc/vuln-scanner/templates/"
	elog ""
	elog "REPORTING:"
	elog "Reports are stored in /var/log/security-scans/"
}
