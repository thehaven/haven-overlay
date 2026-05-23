# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@aws-sdk/util-locate-window"

inherit npm

DESCRIPTION="[![NPM version](https://img.shields.io/npm/v/@aws-sdk/util-locate-window/latest.svg)](https://www.npmjs.com/package/@aws-sdk/util-locate-window) [![NPM downloads](https://img.shields.io/npm/dm/@aws-sdk/util-locate-window.svg)](https://www.npmjs.com/packag"
HOMEPAGE="https://github.com/aws/aws-sdk-js-v3/tree/main/packages-internal/util-locate-window"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
