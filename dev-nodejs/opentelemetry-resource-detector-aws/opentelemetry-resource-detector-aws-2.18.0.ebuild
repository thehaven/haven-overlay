# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opentelemetry/resource-detector-aws"
inherit npm

DESCRIPTION="OpenTelemetry SDK resource detector for AWS"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/resource-detector-aws#readme"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opentelemetry-core
	dev-nodejs/opentelemetry-resources
	dev-nodejs/opentelemetry-semantic-conventions
"
BDEPEND="${RDEPEND}"
