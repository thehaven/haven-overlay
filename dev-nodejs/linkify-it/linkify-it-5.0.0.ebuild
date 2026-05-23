# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="linkify-it"
inherit npm

DESCRIPTION="Links recognition library with FULL unicode support"
HOMEPAGE="https://github.com/markdown-it/linkify-it#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/uc-micro
"
BDEPEND="${RDEPEND}"
