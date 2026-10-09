# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Shared utilities for CrewAI (version, paths, user data, telemetry, printer)"
HOMEPAGE="https://github.com/crewAIInc/crewAI"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}")"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Dependencies mirror crewai-core 1.15.26 pyproject.toml [project].dependencies
# exactly. PEP 440 ~= / <= / >= ranges translated to Gentoo atoms.
RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	>=dev-python/cryptography-42.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/portalocker[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-2.13.0[${PYTHON_USEDEP}]
	<dev-python/pyjwt-3
	>=dev-python/pydantic-2.11.9[${PYTHON_USEDEP}]
	<dev-python/pydantic-2.13
	>=dev-python/rich-13.7.1[${PYTHON_USEDEP}]
	>=dev-python/opentelemetry-api-1.42[${PYTHON_USEDEP}]
	<dev-python/opentelemetry-api-2
	>=dev-python/opentelemetry-sdk-1.42[${PYTHON_USEDEP}]
	<dev-python/opentelemetry-sdk-2
	>=dev-python/opentelemetry-exporter-otlp-proto-http-1.42[${PYTHON_USEDEP}]
	<dev-python/opentelemetry-exporter-otlp-proto-http-2
	dev-python/tomli[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

# Upstream test suite requires live API access and remote services
RESTRICT="test"

distutils_enable_tests pytest
