# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="is-fullwidth-code-point"
inherit npm

DESCRIPTION="Check if the character represented by a given Unicode code point is fullwidth"
HOMEPAGE="https://github.com/sindresorhus/is-fullwidth-code-point#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/get-east-asian-width
"
BDEPEND="${RDEPEND}"
