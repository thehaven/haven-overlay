# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="parse-link-header"
inherit npm

DESCRIPTION="Parses a link header and returns paging information for each contained link."
HOMEPAGE="https://github.com/thlorenz/parse-link-header"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/xtend
"
BDEPEND="${RDEPEND}"
