# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@smithy/util-base64"

inherit npm

DESCRIPTION="A Base64 <-> UInt8Array converter"
HOMEPAGE="https://github.com/smithy-lang/smithy-typescript/tree/main/packages/util-base64"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/smithy-core
	dev-nodejs/tslib
"
BDEPEND=""
