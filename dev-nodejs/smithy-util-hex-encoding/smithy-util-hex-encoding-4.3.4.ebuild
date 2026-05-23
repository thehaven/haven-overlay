# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@smithy/util-hex-encoding"

inherit npm

DESCRIPTION="Converts binary buffers to and from lowercase hexadecimal encoding"
HOMEPAGE="https://github.com/smithy-lang/smithy-typescript/tree/main/packages/util-hex-encoding"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/smithy-core
	dev-nodejs/tslib
"
BDEPEND=""
