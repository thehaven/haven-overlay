# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="CLI utility to save and restore Grafana dashboards via HTTP API"
HOMEPAGE="https://github.com/Beam-Connectivity/grafana-dashboard-manager"
SDIST_URL="https://files.pythonhosted.org/packages/f1/d2/6e276e6fbed848f9ddd6e8ccd51b0c2aa71e307ae69dfa7302275af20b71/grafana_dashboard_manager-0.2.10.92469056881.tar.gz"
SRC_URI="${SDIST_URL}"
S="${WORKDIR}/grafana_dashboard_manager-0.2.10.92469056881"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-python/poetry-core[${PYTHON_USEDEP}]"

RDEPEND="
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
"
