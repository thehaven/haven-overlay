# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/credential-provider-cognito-identity"

inherit npm

DESCRIPTION="[![NPM version](https://img.shields.io/npm/v/@aws-sdk/credential-provider-cognito-identity/latest.svg)](https://www.npmjs.com/package/@aws-sdk/credential-provider-cognito-identity) [![NPM downloads](https://img.shields.io/npm/dm/@aws-sdk/credential-provid"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages-internal/credential-provider-cognito-identity"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-sdk-nested-clients
	dev-nodejs/aws-sdk-types
	dev-nodejs/smithy-core
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND=""
