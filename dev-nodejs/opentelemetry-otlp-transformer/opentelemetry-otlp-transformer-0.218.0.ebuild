# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opentelemetry/otlp-transformer"
inherit npm

DESCRIPTION="Transform OpenTelemetry SDK data into OTLP"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js/tree/main/experimental/packages/otlp-transformer"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opentelemetry-api-logs
	dev-nodejs/opentelemetry-core
	dev-nodejs/opentelemetry-resources
	dev-nodejs/opentelemetry-sdk-logs
	dev-nodejs/opentelemetry-sdk-metrics
	dev-nodejs/opentelemetry-sdk-trace-base
"
BDEPEND="${RDEPEND}"
