# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="side-channel-list"

inherit npm

DESCRIPTION="Store information about any JS value in a side channel, using a linked list"
HOMEPAGE="https://github.com/ljharb/side-channel-list#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/es-errors
	dev-nodejs/object-inspect
"
BDEPEND="${RDEPEND}"
