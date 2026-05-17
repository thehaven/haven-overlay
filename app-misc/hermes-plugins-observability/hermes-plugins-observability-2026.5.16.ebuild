# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Hermes Agent Observability Plugin"
HOMEPAGE="https://github.com/NousResearch/hermes-agent"
SRC_URI="https://github.com/NousResearch/hermes-agent/archive/refs/tags/v${PV}.tar.gz -> hermes-agent-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
S="${WORKDIR}/hermes-agent-${PV}/plugins/."
KEYWORDS="~amd64"

DEPEND=">=app-misc/hermes-2026.5.16"
RDEPEND="${DEPEND}
	dev-python/typer[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/opentelemetry-api[${PYTHON_USEDEP}]
	dev-python/opentelemetry-sdk[${PYTHON_USEDEP}]
	dev-python/opentelemetry-exporter-otlp[${PYTHON_USEDEP}]
"

PYTHON_COMPAT=( python3_{11..12} )
S="${WORKDIR}/hermes-agent-${PV}/plugins/observability"

python_install() {
	distutils-r1_python_install
	python_optimize
}

pkg_postinst() {
	einfo "Hermes Observability plugin installed successfully!"
	einfo ""
	einfo "This plugin provides comprehensive observability capabilities for"
	einfo "Hermes Agent including metrics, traces, and logging."
	einfo ""
	einfo "Features:"
	einfo "  - OpenTelemetry integration"
	einfo "  - Performance metrics collection"
	einfo "  - Distributed tracing"
	einfo "  - Structured logging"
	einfo ""
	einfo "To use the observability plugin:"
	einfo "1. Configure OpenTelemetry exporter settings"
	einfo "2. Set up metrics and tracing endpoints"
	einfo "3. Enable the plugin in Hermes configuration"
	einfo ""
	einfo "For more information, see the Hermes Agent documentation."
}
