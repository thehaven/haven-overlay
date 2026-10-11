# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
#
# cel-python is distributed under the Apache-2.0 license (see LICENSE).

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
PYPI_PN="cel_python"

inherit distutils-r1 pypi

DESCRIPTION="Pure Python implementation of Google Common Expression Language (CEL)"
HOMEPAGE="https://github.com/cloud-custodian/cel-python"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Dependencies mirror cel-python 0.5.0 pyproject.toml [project].dependencies.
# `tomli` is only required on python < 3.11 and is therefore omitted.
RDEPEND="
	>=dev-python/google-re2-1.1.20240702[${PYTHON_USEDEP}]
	>=dev-python/jmespath-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/lark-1.2.2[${PYTHON_USEDEP}]
	>=dev-python/pendulum-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
"

# Upstream test suite (behave/pytest conformance suite) needs the Google CEL
# conformance protocol buffers, which are not packaged.
RESTRICT="test"
