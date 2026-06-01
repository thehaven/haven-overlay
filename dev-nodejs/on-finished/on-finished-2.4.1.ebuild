# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="on-finished"
inherit npm

DESCRIPTION="Execute a callback when a request closes, finishes, or errors"
HOMEPAGE="https://github.com/jshttp/on-finished#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/ee-first
"
BDEPEND="${RDEPEND}"
