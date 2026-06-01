# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@opentelemetry/core"


DESCRIPTION="OpenTelemetry Core provides constants and utilities shared by all OpenTelemetry SDK packages."
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js/tree/main/packages/opentelemetry-core"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opentelemetry-semantic-conventions
"
BDEPEND=""
