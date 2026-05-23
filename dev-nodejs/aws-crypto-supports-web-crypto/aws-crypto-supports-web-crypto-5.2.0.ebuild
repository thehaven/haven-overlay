# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@aws-crypto/supports-web-crypto"


DESCRIPTION="Provides functions for detecting if the host environment supports the WebCrypto API"
HOMEPAGE="https://github.com/aws/aws-sdk-js-crypto-helpers/tree/master/packages/supports-web-crypto"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/tslib
"
BDEPEND=""
