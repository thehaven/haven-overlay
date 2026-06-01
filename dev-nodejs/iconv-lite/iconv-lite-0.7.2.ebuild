# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="iconv-lite"
inherit npm

DESCRIPTION="Convert character encodings in pure javascript."
HOMEPAGE="https://github.com/pillarjs/iconv-lite"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/safer-buffer
"
BDEPEND="${RDEPEND}"
