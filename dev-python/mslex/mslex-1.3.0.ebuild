# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 pypi

DESCRIPTION="shlex for Windows — cross-platform shell quoting"
HOMEPAGE="https://github.com/smoofra/mslex"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
