# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="keyv"
inherit npm

DESCRIPTION="Simple key-value storage with support for multiple backends"
HOMEPAGE="https://github.com/jaredwray/keyv"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/keyv-serialize
"
BDEPEND="${RDEPEND}"
