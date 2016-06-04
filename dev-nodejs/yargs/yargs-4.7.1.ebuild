# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit npm

DESCRIPTION="YAML 1.2 parser and serializer."

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="example"

DEPEND=""
RDEPEND=">=dev-nodejs/camelcase-3.0.0
	>=dev-nodejs/cliui-3.0.0
	net-libs/nodejs
	>=dev-nodejs/decemelize-1.1.1
	>=dev-nodejs/lodash-assign-4.0.3
	>=dev-nodejs/os-locale-1.4.0
	>=dev-nodejs/pkg-conf-1.1.2
	>=dev-nodejs/require-main-filename-1.0.1
	>=dev-nodejs/set-blocking-1.0.0
	>=dev-nodejs/string-width-1.0.1
	>=dev-nodejs/window-size-0.2.0
	>=dev-nodejs/y18n-3.2.1
	>=dev-nodejs/yargs-parser-2.4.0
	${DEPEND}"

src_install() {
	npm_src_install 

	dobin bin/${PN}.js

	if use example; then
		dodoc -r examples
	fi
}
