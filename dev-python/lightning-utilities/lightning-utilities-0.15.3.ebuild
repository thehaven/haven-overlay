# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# lightning-utilities — source-build notes
# ------------------------------------------------------------------
# Upstream pyproject.toml declares requires = [packaging, setuptools,
# wheel] with NO build-backend, which defaults to setuptools per PEP 517.
# The actual build is driven by setup.py, which loads requirements from
# requirements/core.txt and emits extras from requirements/*.txt.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="PyTorch Lightning collective utility library"
HOMEPAGE="https://github.com/Lightning-AI/utilities"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/packaging-22[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
