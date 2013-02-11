# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

WSTX_PV="4.1.1"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Experimental extended Stax API, used by Woodstox"
HOMEPAGE="http://woodstox.codehaus.org/"
SRC_URI="http://woodstox.codehaus.org/${WSTX_PV}/${PN}-src-${PV}.tar.gz"

LICENSE="Apache-2.0 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="java-virtuals/stax-api:0
	>=virtual/jre-1.4"

DEPEND="java-virtuals/stax-api:0
	>=virtual/jdk-1.4"

JAVA_SRC_DIR="stax2-${PV}/src/java"
JAVA_GENTOO_CLASSPATH="stax-api"
