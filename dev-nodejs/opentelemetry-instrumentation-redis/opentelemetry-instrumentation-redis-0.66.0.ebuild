# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@opentelemetry/instrumentation-redis"


DESCRIPTION="OpenTelemetry instrumentation for \`redis\` database client for Redis"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-redis#readme"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opentelemetry-instrumentation
	dev-nodejs/opentelemetry-redis-common
	dev-nodejs/opentelemetry-semantic-conventions
"
BDEPEND=""
