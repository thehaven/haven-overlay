# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 git-r3

DESCRIPTION="A supervisor for docker-compose apps"
HOMEPAGE="https://harbormaster.readthedocs.io/"
EGIT_REPO_URI="https://github.com/skorokithakis/harbormaster.git"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/click-help-colors[${PYTHON_USEDEP}]
	app-containers/docker-compose
"

S="${WORKDIR}/${P}"
