# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="default-browser"
inherit npm

DESCRIPTION="Get the default browser"
HOMEPAGE="https://github.com/sindresorhus/default-browser#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/bundle-name
	dev-nodejs/default-browser-id
"
BDEPEND="${RDEPEND}"
