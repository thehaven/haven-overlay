# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@smithy/core"

inherit npm

DESCRIPTION="[![NPM version](https://img.shields.io/npm/v/@smithy/core/latest.svg)](https://www.npmjs.com/package/@smithy/core) [![NPM downloads](https://img.shields.io/npm/dm/@smithy/core.svg)](https://www.npmjs.com/package/@smithy/core)"
HOMEPAGE="https://github.com/smithy-lang/smithy-typescript/tree/main/packages/core"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/aws-crypto-crc32
	dev-nodejs/smithy-types
	dev-nodejs/tslib
"
BDEPEND=""
