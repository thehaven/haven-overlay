# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )

inherit python-r1 git-r3

DESCRIPTION="Performance audit, auto-tune, and validation suite for Gentoo hosts"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/gentoo/performance-validator"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/gentoo/performance-validator.git"
EGIT_BRANCH="${PV}"
S="${WORKDIR}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	>=app-shells/bash-5
	${PYTHON_DEPS}
"
BDEPEND="${PYTHON_DEPS}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_unpack() {
	git-r3_src_unpack
}

src_install() {
	# Install the CLI entry point (validate_perf.py self-discovers sitedir)
	exeinto /usr/bin
	newexe validate_perf.py performance-validator

	# Install the importable packages
	python_setup
	python_domodule modules
	python_domodule perf_cli

	# Install the default config file
	insinto /etc/performance-validator
	newins config.toml performance-validator.toml

	# Log and metrics directories
	keepdir /var/log/performance-validator
	keepdir /var/lib/performance-validator

	einstalldocs
}

pkg_postinst() {
	# Apply the system configuration to the user's local copy if no override exists
	if [[ ! -e /etc/performance-validator.toml ]]; then
		cp /etc/performance-validator/performance-validator.toml \
		   /etc/performance-validator.toml 2>/dev/null || true
	fi
}
