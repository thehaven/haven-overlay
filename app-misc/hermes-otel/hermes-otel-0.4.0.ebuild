# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="OpenTelemetry observability for Hermes Agent"
HOMEPAGE="https://github.com/briancaffey/hermes-otel"
SRC_URI="https://github.com/briancaffey/hermes-otel/archive/refs/tags/hermes-otel-v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/hermes-otel-hermes-otel-v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-misc/hermes
	dev-python/opentelemetry-api[${PYTHON_USEDEP}]
	dev-python/opentelemetry-sdk[${PYTHON_USEDEP}]
	dev-python/opentelemetry-exporter-otlp-proto-http[${PYTHON_USEDEP}]
"
