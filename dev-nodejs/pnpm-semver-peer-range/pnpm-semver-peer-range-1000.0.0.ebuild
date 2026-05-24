# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@pnpm/semver.peer-range"


DESCRIPTION="Validates peer ranges"
HOMEPAGE="https://www.npmjs.com/package/pnpm-semver-peer-range"
HOMEPAGE="https://www.npmjs.com/package/pnpm-semver-peer-range"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/semver
"
BDEPEND=""
