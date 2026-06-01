# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="browserslist"
inherit npm

DESCRIPTION="Share target browsers between different front-end tools, like Autoprefixer, Stylelint and babel-env-preset"
HOMEPAGE="https://github.com/browserslist/browserslist#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/baseline-browser-mapping
	dev-nodejs/caniuse-lite
	dev-nodejs/electron-to-chromium
	dev-nodejs/node-releases
	dev-nodejs/update-browserslist-db
"
BDEPEND="${RDEPEND}"
