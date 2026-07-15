# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# pyannoteai-sdk — source-build notes
# ------------------------------------------------------------------
# Upstream uses hatchling + hatch-vcs for dynamic versioning from git
# tags. The sdist ships PKG-INFO with the version baked in, so the
# hatch-vcs version lookup resolves from PKG-INFO when the archive is
# unpacked outside a git checkout. No network access is required at
# build time.
#
# Upstream install_requires is `requests>=2.32.3`; the user spec
# suggested httpx + pydantic, but mirroring the upstream declaration
# keeps the dependency graph self-consistent.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Official pyannoteAI Python SDK"
HOMEPAGE="https://github.com/pyannoteAI/pyannote-ai-sdk"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-python/hatchling-1.20"
BDEPEND+=" >=dev-python/hatch-vcs-0.4"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
