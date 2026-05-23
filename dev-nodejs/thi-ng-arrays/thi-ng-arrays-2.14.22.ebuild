# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@thi.ng/arrays"

inherit npm

DESCRIPTION="Array / Arraylike utilities"
HOMEPAGE="https://thi.ng/arrays"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/thi-ng-api
	dev-nodejs/thi-ng-checks
	dev-nodejs/thi-ng-compare
	dev-nodejs/thi-ng-equiv
	dev-nodejs/thi-ng-errors
	dev-nodejs/thi-ng-random
"
BDEPEND="${RDEPEND}"
