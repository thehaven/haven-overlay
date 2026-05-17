# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="opentelemetry-exporter-otlp-proto-common"
inherit distutils-r1 pypi

DESCRIPTION="OpenTelemetry Python OTLP Proto Common"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-python"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/opentelemetry-api[${PYTHON_USEDEP}]
	dev-python/opentelemetry-proto[${PYTHON_USEDEP}]
"
