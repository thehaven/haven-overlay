# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-crypto/util"
inherit npm

DESCRIPTION="Helper functions"
HOMEPAGE="https://github.com/aws/aws-sdk-js-crypto-helpers/tree/master/packages/util"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-sdk-types
	dev-nodejs/smithy-util-utf8
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
