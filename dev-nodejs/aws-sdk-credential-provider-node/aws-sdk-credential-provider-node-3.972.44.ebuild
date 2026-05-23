# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/credential-provider-node"
inherit npm

DESCRIPTION="AWS credential provider that sources credentials from a Node.JS environment. "
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages-internal/credential-provider-node"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-sdk-credential-provider-env
	dev-nodejs/aws-sdk-credential-provider-http
	dev-nodejs/aws-sdk-credential-provider-ini
	dev-nodejs/aws-sdk-credential-provider-process
	dev-nodejs/aws-sdk-credential-provider-sso
	dev-nodejs/aws-sdk-credential-provider-web-identity
	dev-nodejs/aws-sdk-types
	dev-nodejs/smithy-core
	dev-nodejs/smithy-credential-provider-imds
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
