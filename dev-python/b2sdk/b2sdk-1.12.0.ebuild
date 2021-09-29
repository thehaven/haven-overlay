# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5..10} )
inherit distutils-r1

DESCRIPTION="This repository contains a client library and a few handy utilities for easy access to all of the capabilities of B2 Cloud Storage"
HOMEPAGE="https://github.com/Backblaze/b2-sdk-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-python/arrow-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/logfury-0.1.2[${PYTHON_USEDEP}]
		>=dev-python/requests-2.9.1[${PYTHON_USEDEP}]
		>=dev-python/tqdm-4.5.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""
