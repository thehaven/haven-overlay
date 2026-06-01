# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@npmcli/fs"


DESCRIPTION="filesystem utilities for the npm cli"
HOMEPAGE="https://github.com/npm/fs#readme"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/semver
"
BDEPEND=""
