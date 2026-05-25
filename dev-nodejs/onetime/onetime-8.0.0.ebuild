# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="onetime"
inherit npm

DESCRIPTION="Ensure a function is only called once"
HOMEPAGE="https://github.com/sindresorhus/onetime#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/mimic-function
"
BDEPEND="${RDEPEND}"
