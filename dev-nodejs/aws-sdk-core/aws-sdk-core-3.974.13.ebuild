# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/core"

inherit npm

DESCRIPTION="Core functions & classes shared by multiple AWS SDK clients."
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages-internal/core"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-lambda-invoke-store
	dev-nodejs/aws-sdk-types
	dev-nodejs/aws-sdk-xml-builder
	dev-nodejs/bowser
	dev-nodejs/smithy-core
	dev-nodejs/smithy-signature-v4
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND=""
