# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@aws-sdk/crc64-nvme"


DESCRIPTION="A pure JS implementation of CRC64-NVME checksum"
HOMEPAGE="https://www.npmjs.com/package/aws-sdk-crc64-nvme"
HOMEPAGE="https://www.npmjs.com/package/aws-sdk-crc64-nvme"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND=""
