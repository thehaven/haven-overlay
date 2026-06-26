# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@dr.pogodin/csurf"
inherit npm

DESCRIPTION="CSRF token middleware for ExpressJS"
HOMEPAGE="https://dr.pogodin.studio/docs/csurf"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=""
BDEPEND="${RDEPEND}"
