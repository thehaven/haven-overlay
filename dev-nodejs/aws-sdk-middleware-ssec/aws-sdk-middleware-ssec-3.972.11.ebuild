# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/middleware-ssec"

inherit npm

DESCRIPTION="[![NPM version](https://img.shields.io/npm/v/@aws-sdk/middleware-ssec/latest.svg)](https://www.npmjs.com/package/@aws-sdk/middleware-ssec) [![NPM downloads](https://img.shields.io/npm/dm/@aws-sdk/middleware-ssec.svg)](https://www.npmjs.com/package/@aws-sd"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages-internal/middleware-ssec"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-sdk-types
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
