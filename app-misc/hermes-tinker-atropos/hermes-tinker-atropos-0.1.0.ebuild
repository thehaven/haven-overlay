# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1

DESCRIPTION="RL training backend for Hermes Agent"
HOMEPAGE="https://github.com/NousResearch/hermes-agent"
SRC_URI="https://github.com/NousResearch/hermes-agent/archive/v2026.5.7.tar.gz -> hermes-agent-0.13.0.tar.gz"
S="${WORKDIR}/hermes-agent-2026.5.7/tinker-atropos"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-misc/hermes
	dev-python/tinker[${PYTHON_USEDEP}]
"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
