# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/credential-provider-http"

inherit npm

DESCRIPTION="AWS credential provider for containers and HTTP sources"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages-internal/credential-provider-http"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-sdk-core
	dev-nodejs/aws-sdk-types
	dev-nodejs/smithy-core
	dev-nodejs/smithy-fetch-http-handler
	dev-nodejs/smithy-node-http-handler
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND=""
