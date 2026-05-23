# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="async-mutex"

inherit npm

DESCRIPTION="A mutex for guarding async workflows"
HOMEPAGE="https://github.com/DirtyHairy/async-mutex#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/tslib
"
BDEPEND="${RDEPEND}"
