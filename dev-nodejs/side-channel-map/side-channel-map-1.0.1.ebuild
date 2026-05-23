# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="side-channel-map"

inherit npm

DESCRIPTION="Store information about any JS value in a side channel, using a Map"
HOMEPAGE="https://github.com/ljharb/side-channel-map#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/call-bound
	dev-nodejs/es-errors
	dev-nodejs/get-intrinsic
	dev-nodejs/object-inspect
"
BDEPEND=""
