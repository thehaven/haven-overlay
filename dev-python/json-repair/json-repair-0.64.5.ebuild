# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 pypi

DESCRIPTION="Repair broken JSON strings (parser for LLM outputs)"
HOMEPAGE="https://github.com/mangiucugna/json_repair"
PYPI_PN="json_repair"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# sdist ships no test suite; the schema extras (jsonschema/pydantic) are
# only needed for optional pydantic-model repair and are not enabled.
RESTRICT="test"
