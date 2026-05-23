# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="has-property-descriptors"

inherit npm

DESCRIPTION="Does the environment have full property descriptor support? Handles IE 8's broken defineProperty/gOPD."
HOMEPAGE="https://github.com/inspect-js/has-property-descriptors#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/es-define-property
"
BDEPEND=""
