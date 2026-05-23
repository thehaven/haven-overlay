# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opentelemetry/context-async-hooks"
inherit npm

DESCRIPTION="OpenTelemetry AsyncLocalStorage-based Context Manager"
HOMEPAGE="https://github.com/open-telemetry/opentelemetry-js/tree/main/packages/opentelemetry-context-async-hooks"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="

"
BDEPEND="${RDEPEND}"
