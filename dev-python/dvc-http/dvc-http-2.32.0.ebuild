# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1

DESCRIPTION="HTTP plugin for DVC"
HOMEPAGE="https://github.com/iterative/dvc-http"
SRC_URI="https://github.com/iterative/dvc-http/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/dvc
	dev-python/fsspec
	dev-python/requests
"
