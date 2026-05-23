# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@smithy/util-retry"

inherit npm

DESCRIPTION="Shared retry utilities to be used in middleware packages."
HOMEPAGE="https://github.com/smithy-lang/smithy-typescript/tree/master/packages/util-retry"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/smithy-core
	dev-nodejs/tslib
"
BDEPEND=""
