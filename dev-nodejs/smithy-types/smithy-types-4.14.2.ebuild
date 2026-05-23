# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@smithy/types"


DESCRIPTION="[![NPM version](https://img.shields.io/npm/v/@smithy/types/latest.svg)](https://www.npmjs.com/package/@smithy/types) [![NPM downloads](https://img.shields.io/npm/dm/@smithy/types.svg)](https://www.npmjs.com/package/@smithy/types)"
HOMEPAGE="https://github.com/smithy-lang/smithy-typescript/tree/main/packages/types"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/tslib
"
BDEPEND=""
