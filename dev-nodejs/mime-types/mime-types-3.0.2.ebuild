# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="mime-types"
inherit npm

DESCRIPTION="The ultimate javascript content-type utility."
HOMEPAGE="https://github.com/jshttp/mime-types#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/mime-db
"
BDEPEND="${RDEPEND}"
