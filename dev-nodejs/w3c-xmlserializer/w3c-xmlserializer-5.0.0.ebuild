# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="w3c-xmlserializer"
inherit npm

DESCRIPTION="A per-spec XML serializer implementation"
HOMEPAGE="https://github.com/jsdom/w3c-xmlserializer#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/xml-name-validator
"
BDEPEND="${RDEPEND}"
