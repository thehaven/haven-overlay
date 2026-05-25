# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="type-is"
inherit npm

DESCRIPTION="Infer the content-type of a request."
HOMEPAGE="https://github.com/jshttp/type-is#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/content-type
	dev-nodejs/media-typer
	dev-nodejs/mime-types
"
BDEPEND="${RDEPEND}"
