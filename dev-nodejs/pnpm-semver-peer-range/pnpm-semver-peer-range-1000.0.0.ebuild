# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@pnpm/semver.peer-range"
inherit npm

DESCRIPTION="Validates peer ranges"
HOMEPAGE="https://github.com/pnpm/pnpm/blob/main/semver/peer-range#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/semver
"
BDEPEND="${RDEPEND}"
