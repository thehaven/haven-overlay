# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="parse-url"


DESCRIPTION="An advanced url parser supporting git urls too."
HOMEPAGE="https://github.com/IonicaBizau/parse-url"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/parse-path
"
BDEPEND=""
