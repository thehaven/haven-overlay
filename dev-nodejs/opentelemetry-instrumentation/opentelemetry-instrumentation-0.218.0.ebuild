# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opentelemetry/instrumentation"

inherit npm

DESCRIPTION="Base class for node which OpenTelemetry instrumentation modules extend"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js/tree/main/experimental/packages/opentelemetry-instrumentation"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/import-in-the-middle
	dev-nodejs/opentelemetry-api-logs
	dev-nodejs/require-in-the-middle
"
BDEPEND=""
