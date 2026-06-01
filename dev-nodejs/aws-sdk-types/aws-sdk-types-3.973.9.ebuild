# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@aws-sdk/types"


DESCRIPTION="Types for the AWS SDK"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages-internal/types"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND=""
