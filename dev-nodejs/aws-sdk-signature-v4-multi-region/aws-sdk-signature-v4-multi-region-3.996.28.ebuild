# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/signature-v4-multi-region"

inherit npm

DESCRIPTION="[![NPM version](https://img.shields.io/npm/v/@aws-sdk/signature-v4-multi-region/latest.svg)](https://www.npmjs.com/package/@aws-sdk/signature-v4-multi-region) [![NPM downloads](https://img.shields.io/npm/dm/@aws-sdk/signature-v4-multi-region.svg)](https:/"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages/signature-v4-multi-region"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-sdk-types
	dev-nodejs/smithy-core
	dev-nodejs/smithy-signature-v4
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
