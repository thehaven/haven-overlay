# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit npm

DESCRIPTION="Extension of the Mustache logicless template language"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND="net-libs/nodejs
	>=dev-nodejs/optimist-0.6.1
	>=dev-nodejs/uglify-js-2.6
	>=dev-nodejs/source-map-0.4.4
	${DEPEND}"
