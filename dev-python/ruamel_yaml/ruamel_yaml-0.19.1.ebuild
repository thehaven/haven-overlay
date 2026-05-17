# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="ruamel.yaml"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="ruamel.yaml is a YAML parser/emitter for Python"
HOMEPAGE="https://sourceforge.net/projects/ruamel-yaml/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
