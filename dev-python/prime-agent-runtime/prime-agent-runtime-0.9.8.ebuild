# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Kernel-side runtime shim for Prime Agent recursion (rlm module)"
HOMEPAGE="https://github.com/PrimeIntellect-ai/prime-agent"
# The runtime ships inside the prime-agent monorepo (prime-agent-runtime/);
# there is no standalone PyPI release. ebuild PV follows the repo tag, even
# though pyproject.toml self-identifies as 0.1.0.
SRC_URI="https://github.com/PrimeIntellect-ai/prime-agent/archive/refs/tags/v${PV}.tar.gz -> prime-agent-${PV}.tar.gz"

S="${WORKDIR}/prime-agent-${PV}/prime-agent-runtime"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Test suite is part of the prime-agent repo CI; not needed at build time.
RESTRICT="test"

# mirrors [project].dependencies in prime-agent-runtime/pyproject.toml
RDEPEND="
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/nest-asyncio[${PYTHON_USEDEP}]
	dev-python/tyro[${PYTHON_USEDEP}]
"
