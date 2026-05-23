# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/middleware-sdk-s3"
inherit npm

DESCRIPTION="[![NPM version](https://img.shields.io/npm/v/@aws-sdk/middleware-sdk-s3/latest.svg)](https://www.npmjs.com/package/@aws-sdk/middleware-sdk-s3) [![NPM downloads](https://img.shields.io/npm/dm/@aws-sdk/middleware-sdk-s3.svg)](https://www.npmjs.com/package/@"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages-internal/middleware-sdk-s3"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-sdk-core
	dev-nodejs/aws-sdk-signature-v4-multi-region
	dev-nodejs/aws-sdk-types
	dev-nodejs/smithy-core
	dev-nodejs/smithy-signature-v4
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
