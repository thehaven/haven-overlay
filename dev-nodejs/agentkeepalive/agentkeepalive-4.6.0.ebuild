# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="agentkeepalive"

inherit npm

DESCRIPTION="Missing keepalive http.Agent"
HOMEPAGE="https://github.com/node-modules/agentkeepalive#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/humanize-ms
"
BDEPEND="${RDEPEND}"
