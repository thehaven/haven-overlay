# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="google-auth-library"

inherit npm

DESCRIPTION="Google APIs Authentication Client Library for Node.js"
HOMEPAGE="https://github.com/googleapis/google-cloud-node-core/tree/main/packages/google-auth-library-nodejs"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/base64-js
	dev-nodejs/ecdsa-sig-formatter
	dev-nodejs/gaxios
	dev-nodejs/gcp-metadata
	dev-nodejs/google-logging-utils
	dev-nodejs/jws
"
BDEPEND="${RDEPEND}"
