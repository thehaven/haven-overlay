# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@kwsites/file-exists"

inherit npm

DESCRIPTION="Synchronous validation of a path existing either as a file or as a directory."
HOMEPAGE="https://github.com/kwsites/file-exists#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/debug
"
BDEPEND="${RDEPEND}"
