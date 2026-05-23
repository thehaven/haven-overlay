# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="json-dup-key-validator"

inherit npm

DESCRIPTION="A json validator that has an option to check for duplicated keys"
HOMEPAGE="https://github.com/jackyjieliu/json-dup-key-validator"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/backslash
"
BDEPEND=""
