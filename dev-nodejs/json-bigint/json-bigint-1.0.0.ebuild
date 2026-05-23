# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="json-bigint"


DESCRIPTION="JSON.parse with bigints support"
HOMEPAGE="https://github.com/sidorares/json-bigint#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/bignumber-js
"
BDEPEND=""
