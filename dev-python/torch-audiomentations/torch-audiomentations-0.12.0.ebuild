# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# torch-audiomentations — source-build notes
# ------------------------------------------------------------------
# Upstream declares a PEP 517 build-system of setuptools + wheel in
# pyproject.toml but the wheel itself is produced by setup.cfg +
# setup.py. We use DISTUTILS_USE_PEP517=setuptools.
#
# Hard runtime deps (julius>=0.2.3,<0.3 and torch-pitch-shift>=1.2.2)
# are not yet packaged in ::gentoo or this overlay; emerge will fail
# until they are added.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="GPU-based audio augmentations library for PyTorch"
HOMEPAGE="https://github.com/asteroid-team/torch-audiomentations"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# TODO: package dev-python/julius and dev-python/torch-pitch-shift so
# this RDEPEND resolves.
RDEPEND="
	>=dev-python/torch-2.0[${PYTHON_USEDEP}]
	>=dev-python/torchaudio-2.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
