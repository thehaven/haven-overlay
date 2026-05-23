# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@smithy/protocol-http"

inherit npm

DESCRIPTION="Node.js module"
HOMEPAGE="https://github.com/smithy-lang/smithy-typescript/tree/main/packages/protocol-http"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/smithy-core
	dev-nodejs/tslib
"
BDEPEND=""
