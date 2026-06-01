# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="mv"


DESCRIPTION="fs.rename but works across devices. same as the unix utility 'mv'"
HOMEPAGE="https://github.com/andrewrk/node-mv"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/mkdirp
	dev-nodejs/ncp
	dev-nodejs/rimraf
"
BDEPEND=""
