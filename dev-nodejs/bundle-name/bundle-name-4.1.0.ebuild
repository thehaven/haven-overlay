# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="bundle-name"
inherit npm

DESCRIPTION="Get bundle name from a bundle identifier (macOS): \`com.apple.Safari\` → \`Safari\`"
HOMEPAGE="https://github.com/sindresorhus/bundle-name#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/run-applescript
"
BDEPEND="${RDEPEND}"
