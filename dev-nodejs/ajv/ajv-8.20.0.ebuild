# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="ajv"
inherit npm

DESCRIPTION="Another JSON Schema Validator"
HOMEPAGE="https://ajv.js.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/fast-deep-equal
	dev-nodejs/fast-uri
	dev-nodejs/json-schema-traverse
	dev-nodejs/require-from-string
"
BDEPEND="${RDEPEND}"
