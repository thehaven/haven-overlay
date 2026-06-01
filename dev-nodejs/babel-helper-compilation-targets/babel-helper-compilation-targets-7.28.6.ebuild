# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/helper-compilation-targets"
inherit npm

DESCRIPTION="Helper functions on Babel compilation targets"
HOMEPAGE="https://www.npmjs.com/package/@babel/helper-compilation-targets"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-compat-data
	dev-nodejs/babel-helper-validator-option
	dev-nodejs/browserslist
	dev-nodejs/lru-cache
	dev-nodejs/semver
"
BDEPEND="${RDEPEND}"
