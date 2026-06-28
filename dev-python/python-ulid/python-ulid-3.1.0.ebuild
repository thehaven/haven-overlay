# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="python-ulid"
inherit distutils-r1 pypi

# pyproject.toml [build-system].requires declares these as build-time plugins:
#   hatch-fancy-pypi-readme provides the "fancy-pypi-readme" metadata hook
#   hatch-vcs provides VCS-based version resolution (falls back to PKG-INFO in sdist)
# Both must be in BDEPEND; without hatch-fancy-pypi-readme the build fails with
# `UnknownPluginError: Unknown metadata hook: fancy-pypi-readme`.
BDEPEND="
	dev-python/hatch-fancy-pypi-readme
	dev-python/hatch-vcs
"

DESCRIPTION="python-ulid Python package"
HOMEPAGE="https://github.com/mdomke/python-ulid"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
