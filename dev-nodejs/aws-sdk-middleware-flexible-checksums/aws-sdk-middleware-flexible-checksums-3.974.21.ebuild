# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/middleware-flexible-checksums"
inherit npm

DESCRIPTION="[![NPM version](https://img.shields.io/npm/v/@aws-sdk/middleware-flexible-checksums/latest.svg)](https://www.npmjs.com/package/@aws-sdk/middleware-flexible-checksums) [![NPM downloads](https://img.shields.io/npm/dm/@aws-sdk/middleware-flexible-checksums.s"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages-internal/middleware-flexible-checksums"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-crypto-crc32
	dev-nodejs/aws-crypto-crc32c
	dev-nodejs/aws-crypto-util
	dev-nodejs/aws-sdk-core
	dev-nodejs/aws-sdk-crc64-nvme
	dev-nodejs/aws-sdk-types
	dev-nodejs/smithy-core
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
