# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-crypto/sha256-js"

inherit npm

DESCRIPTION="A pure JS implementation SHA256."
HOMEPAGE="https://github.com/aws/aws-sdk-js-crypto-helpers/tree/master/packages/sha256-js"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-crypto-util
	dev-nodejs/aws-sdk-types
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
