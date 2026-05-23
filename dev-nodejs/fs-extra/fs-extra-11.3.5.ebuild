# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="fs-extra"

inherit npm

DESCRIPTION="fs-extra contains methods that aren't included in the vanilla Node.js fs package. Such as recursive mkdir, copy, and remove."
HOMEPAGE="https://github.com/jprichardson/node-fs-extra"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/graceful-fs
	dev-nodejs/jsonfile
	dev-nodejs/universalify
"
BDEPEND="${RDEPEND}"
