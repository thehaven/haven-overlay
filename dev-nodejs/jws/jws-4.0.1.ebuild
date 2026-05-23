# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="jws"


DESCRIPTION="Implementation of JSON Web Signatures"
HOMEPAGE="https://github.com/brianloveswords/node-jws#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/jwa
	dev-nodejs/safe-buffer
"
BDEPEND=""
