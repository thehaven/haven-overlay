# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="ajv-formats"
inherit npm

DESCRIPTION="Format validation for Ajv v7+"
HOMEPAGE="https://github.com/ajv-validator/ajv-formats#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/ajv
"
BDEPEND="${RDEPEND}"
