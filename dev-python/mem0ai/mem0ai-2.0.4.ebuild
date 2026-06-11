# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="The Memory Layer for Personalized AI"
HOMEPAGE="https://github.com/mem0ai/mem0"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/openai-1.90.0[${PYTHON_USEDEP}]
	>=dev-python/posthog-4.5.0[${PYTHON_USEDEP}]
	<dev-python/protobuf-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-5.29.6[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.7.3[${PYTHON_USEDEP}]
	>=dev-python/pytz-2024.1[${PYTHON_USEDEP}]
	>=dev-python/qdrant-client-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-2.0.41[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
