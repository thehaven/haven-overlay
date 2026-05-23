# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@renovatebot/good-enough-parser"

inherit npm

DESCRIPTION="Parse and query computer programs source code"
HOMEPAGE="https://github.com/renovatebot/good-enough-parser#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/klona
	dev-nodejs/moo
	dev-nodejs/thi-ng-zipper
	dev-nodejs/types-moo
"
BDEPEND="${RDEPEND}"
