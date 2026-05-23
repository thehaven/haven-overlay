# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@thi.ng/random"

inherit npm

DESCRIPTION="Pseudo-random number generators w/ unified API, distributions, weighted choices, ID generation"
HOMEPAGE="https://thi.ng/random"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/thi-ng-api
	dev-nodejs/thi-ng-errors
"
BDEPEND="${RDEPEND}"
