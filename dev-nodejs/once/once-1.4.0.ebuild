# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="once"
inherit npm

DESCRIPTION="Run a function exactly one time"
HOMEPAGE="https://github.com/isaacs/once#readme"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/wrappy
"
BDEPEND="${RDEPEND}"
