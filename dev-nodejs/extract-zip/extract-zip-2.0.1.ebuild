# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="extract-zip"

inherit npm

DESCRIPTION="unzip a zip file into a directory using 100% javascript"
HOMEPAGE="https://github.com/maxogden/extract-zip#readme"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/debug
	dev-nodejs/get-stream
	dev-nodejs/types-yauzl
	dev-nodejs/yauzl
"
BDEPEND=""
