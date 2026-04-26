# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )
inherit distutils-r1

DESCRIPTION="Microsoft Presidio Anonymizer"
HOMEPAGE="https://github.com/microsoft/presidio"
SRC_URI="https://github.com/microsoft/presidio/archive/refs/tags/${PV}.tar.gz -> presidio-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
    dev-python/pydantic[${PYTHON_USEDEP}]
    dev-python/pyyaml[${PYTHON_USEDEP}]
"

S="${WORKDIR}/presidio-${PV}/presidio-anonymizer"
