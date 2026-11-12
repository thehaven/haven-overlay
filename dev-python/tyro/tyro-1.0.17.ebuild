# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Typed command-line interfaces and configuration from Python type hints"
HOMEPAGE="https://github.com/brentyi/tyro"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Test suite needs the full dev extra (pytest, pydantic, omegaconf,
# ml-collections, flax, ...); not exercised in the overlay build.
RESTRICT="test"

# mirrors [project].dependencies in tyro's pyproject.toml (>=3.8 upstream;
# capped per overlay convention at python3_{11..14})
RDEPEND="
	>=dev-python/docstring-parser-0.16[${PYTHON_USEDEP}]
	>=dev-python/typeguard-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.13.0[${PYTHON_USEDEP}]
"
