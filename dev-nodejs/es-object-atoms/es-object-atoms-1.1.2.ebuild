# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="es-object-atoms"
inherit npm

DESCRIPTION="ES Object-related atoms: Object, ToObject, RequireObjectCoercible"
HOMEPAGE="https://github.com/ljharb/es-object-atoms#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/es-errors
"
BDEPEND="${RDEPEND}"
