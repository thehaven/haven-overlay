# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/helper-optimise-call-expression"
inherit npm

DESCRIPTION="Helper function to optimise call expression"
HOMEPAGE="https://babel.dev/docs/en/next/babel-helper-optimise-call-expression"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-types
"
BDEPEND="${RDEPEND}"
