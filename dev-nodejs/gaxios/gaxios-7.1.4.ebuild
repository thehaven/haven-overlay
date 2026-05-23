# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="gaxios"


DESCRIPTION="A simple common HTTP client specifically for Google APIs and services."
HOMEPAGE="https://github.com/googleapis/google-cloud-node-core/tree/main/packages/gaxios"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/extend
	dev-nodejs/https-proxy-agent
	dev-nodejs/node-fetch
"
BDEPEND=""
