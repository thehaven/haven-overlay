# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="Python port of Inquirer.js — collection of common interactive CLI prompts"
HOMEPAGE="https://github.com/kazhala/InquirerPy"
SRC_URI="https://github.com/kazhala/InquirerPy/archive/v${PV}.tar.gz -> InquirerPy-${PV}.tar.gz"
S="${WORKDIR}/InquirerPy-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/prompt-toolkit-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/pfzy-0.3.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/poetry-core[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
