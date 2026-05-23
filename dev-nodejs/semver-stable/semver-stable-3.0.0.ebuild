# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="semver-stable"
inherit npm

DESCRIPTION="semver-stable"
HOMEPAGE="https://github.com/kaelzhang/node-semver-stable#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/semver
"
BDEPEND="${RDEPEND}"
