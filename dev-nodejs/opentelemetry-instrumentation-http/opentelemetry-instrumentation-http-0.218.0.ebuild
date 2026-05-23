# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opentelemetry/instrumentation-http"

inherit npm

DESCRIPTION="OpenTelemetry instrumentation for \`node:http\` and \`node:https\` http client and server modules"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js/tree/main/experimental/packages/opentelemetry-instrumentation-http"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/forwarded-parse
	dev-nodejs/opentelemetry-core
	dev-nodejs/opentelemetry-instrumentation
	dev-nodejs/opentelemetry-semantic-conventions
"
BDEPEND="${RDEPEND}"
