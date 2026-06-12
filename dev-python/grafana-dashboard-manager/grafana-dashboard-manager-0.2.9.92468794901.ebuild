# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="CLI utility to save and restore Grafana dashboards via HTTP API"
HOMEPAGE="https://github.com/Beam-Connectivity/grafana-dashboard-manager"
SRC_URI="https://files.pythonhosted.org/packages/dd/cc/fe7da0411b44b12530e263a85fbda585c8299665b9d6312b8db07dd6bb06/grafana_dashboard_manager-0.2.9.92468794901.tar.gz"
S="${WORKDIR}/grafana_dashboard_manager-0.2.9.92468794901"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-python/poetry-core[${PYTHON_USEDEP}]"

RDEPEND="
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
"
