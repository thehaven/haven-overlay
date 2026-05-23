# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@opentelemetry/api-logs"


DESCRIPTION="Public logs API for OpenTelemetry"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js/tree/main/experimental/packages/api-logs"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opentelemetry-api
"
BDEPEND=""
