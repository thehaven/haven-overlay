# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@smithy/fetch-http-handler"


DESCRIPTION="Provides a way to make requests"
HOMEPAGE="https://github.com/smithy-lang/smithy-typescript/tree/main/packages/fetch-http-handler"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/smithy-core
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND=""
