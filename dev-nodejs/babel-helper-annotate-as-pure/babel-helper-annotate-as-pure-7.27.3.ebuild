# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/helper-annotate-as-pure"
inherit npm

DESCRIPTION="Helper function to annotate paths and nodes with #__PURE__ comment"
HOMEPAGE="https://babel.dev/docs/en/next/babel-helper-annotate-as-pure"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-types
"
BDEPEND="${RDEPEND}"
