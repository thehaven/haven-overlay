# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="npm-run-path"

inherit npm

DESCRIPTION="Get your PATH prepended with locally installed binaries"
HOMEPAGE="https://github.com/sindresorhus/npm-run-path#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/path-key
	dev-nodejs/unicorn-magic
"
BDEPEND="${RDEPEND}"
