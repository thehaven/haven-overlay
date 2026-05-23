# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@thi.ng/compare"


DESCRIPTION="Comparators with support for types implementing the @thi.ng/api/ICompare interface"
HOMEPAGE="https://thi.ng/compare"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/thi-ng-api
"
BDEPEND=""
