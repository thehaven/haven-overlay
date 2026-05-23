# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="side-channel"

inherit npm

DESCRIPTION="Store information about any JS value in a side channel. Uses WeakMap if available."
HOMEPAGE="https://github.com/ljharb/side-channel#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/es-errors
	dev-nodejs/object-inspect
	dev-nodejs/side-channel-list
	dev-nodejs/side-channel-map
	dev-nodejs/side-channel-weakmap
"
BDEPEND="${RDEPEND}"
