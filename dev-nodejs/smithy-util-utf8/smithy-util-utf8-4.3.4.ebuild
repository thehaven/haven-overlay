# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@smithy/util-utf8"


DESCRIPTION="A UTF-8 string <-> UInt8Array converter"
HOMEPAGE="https://github.com/smithy-lang/smithy-typescript/tree/main/packages/util-utf8"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/smithy-core
	dev-nodejs/tslib
"
BDEPEND=""
