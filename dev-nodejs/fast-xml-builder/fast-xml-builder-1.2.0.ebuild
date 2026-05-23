# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="fast-xml-builder"
inherit npm

DESCRIPTION="Build XML from JSON without C/C++ based libraries"
HOMEPAGE="https://github.com/NaturalIntelligence/fast-xml-builder#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/path-expression-matcher
	dev-nodejs/xml-naming
"
BDEPEND="${RDEPEND}"
