# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="find-up"
inherit npm

DESCRIPTION="Find a file or directory by walking up parent directories"
HOMEPAGE="https://github.com/sindresorhus/find-up#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/locate-path
	dev-nodejs/unicorn-magic
"
BDEPEND="${RDEPEND}"
