# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@pnpm/manifest-utils"

inherit npm

DESCRIPTION="Utils for dealing with package manifest"
HOMEPAGE="https://github.com/pnpm/pnpm/tree/main/pkg-manifest/manifest-utils#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/pnpm-core-loggers
	dev-nodejs/pnpm-error
	dev-nodejs/pnpm-semver-peer-range
	dev-nodejs/pnpm-types
	dev-nodejs/semver
"
BDEPEND="${RDEPEND}"
