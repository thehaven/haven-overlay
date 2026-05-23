# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="xmldoc"

inherit npm

DESCRIPTION="A lightweight XML Document class for JavaScript."
HOMEPAGE="https://github.com/nfarina/xmldoc#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/sax
"
BDEPEND="${RDEPEND}"
