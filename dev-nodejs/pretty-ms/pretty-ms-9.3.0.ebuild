# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="pretty-ms"

inherit npm

DESCRIPTION="Convert milliseconds to a human readable string: \`1337000000\` → \`15d 11h 23m 20s\`"
HOMEPAGE="https://github.com/sindresorhus/pretty-ms#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/parse-ms
"
BDEPEND="${RDEPEND}"
