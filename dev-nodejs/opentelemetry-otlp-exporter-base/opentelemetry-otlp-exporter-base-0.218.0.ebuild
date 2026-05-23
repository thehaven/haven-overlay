# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opentelemetry/otlp-exporter-base"
inherit npm

DESCRIPTION="OpenTelemetry OTLP Exporter base (for internal use only)"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js/tree/main/experimental/packages/otlp-exporter-base"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opentelemetry-core
	dev-nodejs/opentelemetry-otlp-transformer
"
BDEPEND="${RDEPEND}"
