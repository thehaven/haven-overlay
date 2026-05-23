# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@pnpm/parse-wanted-dependency"
inherit npm

DESCRIPTION="Parse dependency specifier"
HOMEPAGE="https://github.com/pnpm/pnpm/blob/main/packages/parse-wanted-dependency#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/validate-npm-package-name
"
BDEPEND="${RDEPEND}"
