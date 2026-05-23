# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@opentelemetry/exporter-trace-otlp-http"


DESCRIPTION="OpenTelemetry Collector Trace Exporter allows user to send collected traces to the OpenTelemetry Collector"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js/tree/main/experimental/packages/exporter-trace-otlp-http"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opentelemetry-core
	dev-nodejs/opentelemetry-otlp-exporter-base
	dev-nodejs/opentelemetry-otlp-transformer
	dev-nodejs/opentelemetry-resources
	dev-nodejs/opentelemetry-sdk-trace-base
"
BDEPEND=""
