# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="pkg-up"
inherit npm

DESCRIPTION="Find the closest package.json file"
HOMEPAGE="https://github.com/sindresorhus/pkg-up#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/find-up
"
BDEPEND="${RDEPEND}"
