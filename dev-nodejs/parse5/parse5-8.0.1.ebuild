# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="parse5"
inherit npm

DESCRIPTION="HTML parser and serializer."
HOMEPAGE="https://parse5.js.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/entities
"
BDEPEND="${RDEPEND}"
