# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="jwa"

inherit npm

DESCRIPTION="JWA implementation (supports all JWS algorithms)"
HOMEPAGE="https://github.com/brianloveswords/node-jwa#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/buffer-equal-constant-time
	dev-nodejs/ecdsa-sig-formatter
	dev-nodejs/safe-buffer
"
BDEPEND="${RDEPEND}"
