# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opentelemetry/sdk-trace-node"

inherit npm

DESCRIPTION="OpenTelemetry Node SDK provides automatic telemetry (tracing, metrics, etc) for Node.js applications"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js/tree/main/packages/opentelemetry-sdk-trace-node"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opentelemetry-context-async-hooks
	dev-nodejs/opentelemetry-core
	dev-nodejs/opentelemetry-sdk-trace-base
"
BDEPEND="${RDEPEND}"
