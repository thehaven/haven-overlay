# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="locate-path"

inherit npm

DESCRIPTION="Get the first path that exists on disk of multiple paths"
HOMEPAGE="https://github.com/sindresorhus/locate-path#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/p-locate
"
BDEPEND="${RDEPEND}"
