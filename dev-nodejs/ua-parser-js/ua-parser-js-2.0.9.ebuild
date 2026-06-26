# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

DESCRIPTION="Detect Browser, Engine, OS, CPU, and Device type/model from User-Agent & Clie..."
HOMEPAGE="https://uaparser.dev"

LICENSE="AGPL-3.0-or-later"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
BDEPEND="${RDEPEND}"

src_install() {
	npm_src_install
	npm_install_bin "script/cli.js" ua-parser-js
}
