# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="fast-xml-parser"


DESCRIPTION="Validate XML, Parse XML, Build XML without C/C++ based libraries"
HOMEPAGE="https://github.com/NaturalIntelligence/fast-xml-parser#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/fast-xml-builder
	dev-nodejs/nodable-entities
	dev-nodejs/path-expression-matcher
	dev-nodejs/strnum
	dev-nodejs/xml-naming
"
BDEPEND=""
