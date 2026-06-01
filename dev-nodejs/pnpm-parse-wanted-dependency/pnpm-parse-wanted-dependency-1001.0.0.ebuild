# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@pnpm/parse-wanted-dependency"


DESCRIPTION="Parse dependency specifier"
HOMEPAGE="https://www.npmjs.com/package/pnpm-parse-wanted-dependency"
HOMEPAGE="https://www.npmjs.com/package/pnpm-parse-wanted-dependency"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/validate-npm-package-name
"
BDEPEND=""
