# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="micromatch"


DESCRIPTION="Glob matching for javascript/node.js. A replacement and faster alternative to minimatch and multimatch."
HOMEPAGE="https://github.com/micromatch/micromatch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/braces
	dev-nodejs/picomatch
"
BDEPEND=""
