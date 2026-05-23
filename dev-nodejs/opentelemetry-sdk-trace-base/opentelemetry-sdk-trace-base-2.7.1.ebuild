# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opentelemetry/sdk-trace-base"
inherit npm

DESCRIPTION="OpenTelemetry Tracing"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js/tree/main/packages/opentelemetry-sdk-trace-base"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opentelemetry-core
	dev-nodejs/opentelemetry-resources
	dev-nodejs/opentelemetry-semantic-conventions
"
BDEPEND="${RDEPEND}"
