# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/crc64-nvme"
inherit npm

DESCRIPTION="A pure JS implementation of CRC64-NVME checksum"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages/crc64-nvme"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
