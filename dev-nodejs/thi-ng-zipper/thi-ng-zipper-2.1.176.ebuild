# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@thi.ng/zipper"
inherit npm

DESCRIPTION="Functional tree editing, manipulation & navigation"
HOMEPAGE="https://thi.ng/zipper"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/thi-ng-api
	dev-nodejs/thi-ng-arrays
	dev-nodejs/thi-ng-checks
	dev-nodejs/thi-ng-errors
"
BDEPEND="${RDEPEND}"
