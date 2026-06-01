# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="section-matter"
inherit npm

DESCRIPTION="Like front-matter, but supports multiple sections in a document."
HOMEPAGE="https://github.com/jonschlinkert/section-matter"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/extend-shallow
	dev-nodejs/kind-of
"
BDEPEND="${RDEPEND}"
