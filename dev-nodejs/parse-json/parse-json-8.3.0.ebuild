# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="parse-json"

inherit npm

DESCRIPTION="Parse JSON with more helpful errors"
HOMEPAGE="https://github.com/sindresorhus/parse-json#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-code-frame
	dev-nodejs/index-to-position
	dev-nodejs/type-fest
"
BDEPEND="${RDEPEND}"
