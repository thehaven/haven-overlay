# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-crypto/crc32c"

inherit npm

DESCRIPTION="Pure JS implementation of CRC32-C https://en.wikipedia.org/wiki/Cyclic_redundancy_check"
HOMEPAGE="https://github.com/aws/aws-sdk-js-crypto-helpers/tree/master/packages/crc32c"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-crypto-util
	dev-nodejs/aws-sdk-types
	dev-nodejs/tslib
"
BDEPEND=""
