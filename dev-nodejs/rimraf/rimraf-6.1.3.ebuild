# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="rimraf"

inherit npm

DESCRIPTION="A deep deletion module for node (like \`rm -rf\`)"
HOMEPAGE="https://github.com/isaacs/rimraf#readme"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/glob
	dev-nodejs/package-json-from-dist
"
BDEPEND=""
