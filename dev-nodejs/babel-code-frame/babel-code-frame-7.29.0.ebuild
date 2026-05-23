# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@babel/code-frame"


DESCRIPTION="Generate errors that contain a code frame that point to source locations."
HOMEPAGE="https://babel.dev/docs/en/next/babel-code-frame"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-helper-validator-identifier
	dev-nodejs/js-tokens
	dev-nodejs/picocolors
"
BDEPEND=""
