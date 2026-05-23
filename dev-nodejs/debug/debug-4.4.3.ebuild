# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="debug"

inherit npm

DESCRIPTION="Lightweight debugging utility for Node.js and the browser"
HOMEPAGE="https://github.com/debug-js/debug#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/ms
"
BDEPEND="${RDEPEND}"
