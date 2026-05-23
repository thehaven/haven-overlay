# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="fill-range"

inherit npm

DESCRIPTION="Fill in a range of numbers or letters, optionally passing an increment or \`step\` to use, or create a regex-compatible range with \`options.toRegex\`"
HOMEPAGE="https://github.com/jonschlinkert/fill-range"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/to-regex-range
"
BDEPEND=""
