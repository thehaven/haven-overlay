# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/credential-provider-login"
inherit npm

DESCRIPTION="AWS credential provider that sources credentials from aws login cached tokens"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages-internal/credential-provider-login"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-sdk-core
	dev-nodejs/aws-sdk-nested-clients
	dev-nodejs/aws-sdk-types
	dev-nodejs/smithy-core
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
