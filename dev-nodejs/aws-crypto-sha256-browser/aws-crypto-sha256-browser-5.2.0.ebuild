# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-crypto/sha256-browser"

inherit npm

DESCRIPTION="SHA256 wrapper for browsers that prefers \`window.crypto.subtle\` but will fall back to a pure JS implementation in @aws-crypto/sha256-js to provide a consistent interface for SHA256."
HOMEPAGE="https://github.com/aws/aws-sdk-js-crypto-helpers/tree/master/packages/sha256-browser"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-crypto-sha256-js
	dev-nodejs/aws-crypto-supports-web-crypto
	dev-nodejs/aws-crypto-util
	dev-nodejs/aws-sdk-types
	dev-nodejs/aws-sdk-util-locate-window
	dev-nodejs/smithy-util-utf8
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
