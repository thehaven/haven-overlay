# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="is-core-module"
inherit npm

DESCRIPTION="Is this specifier a node.js core module?"
HOMEPAGE="https://github.com/inspect-js/is-core-module"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/hasown
"
BDEPEND="${RDEPEND}"
