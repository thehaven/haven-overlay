# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# pyannote-metrics 4.x — source-build notes
# ------------------------------------------------------------------
# Upstream uses hatchling + hatch-vcs for dynamic versioning from git
# tags. The sdist ships PKG-INFO with the version baked in, so the
# hatch-vcs version lookup resolves from PKG-INFO when the archive is
# unpacked outside a git checkout. No network access is required at
# build time.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Metrics library for pyannote.audio speaker diarization"
HOMEPAGE="https://github.com/pyannote/pyannote-metrics"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-python/hatchling-1.20"

RDEPEND="
	>=dev-python/pyannote-core-5.0[${PYTHON_USEDEP}]
	>=dev-python/pyannote-database-6.0[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.10[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.23[${PYTHON_USEDEP}]
	>=dev-python/scikit-learn-1.6[${PYTHON_USEDEP}]
	>=dev-python/pandas-2.2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
