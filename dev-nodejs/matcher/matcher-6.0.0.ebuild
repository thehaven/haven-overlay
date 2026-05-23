# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="matcher"
inherit npm

DESCRIPTION="Simple wildcard matching"
HOMEPAGE="https://github.com/sindresorhus/matcher#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/escape-string-regexp
"
BDEPEND="${RDEPEND}"
