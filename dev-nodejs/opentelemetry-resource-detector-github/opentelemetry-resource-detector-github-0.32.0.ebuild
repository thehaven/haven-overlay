# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opentelemetry/resource-detector-github"

inherit npm

DESCRIPTION="OpenTelemetry SDK resource detector for GitHub"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/resource-detector-github#readme"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opentelemetry-resources
"
BDEPEND="${RDEPEND}"
