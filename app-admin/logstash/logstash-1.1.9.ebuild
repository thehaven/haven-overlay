# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="logstash is a tool for managing events and logs."
HOMEPAGE="http://logstash.net/"
SRC_URI="https://logstash.objects.dreamhost.com/release/${P}-monolithic.jar"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/jre dev-db/redis dev-db/elasticsearch"
RDEPEND="${DEPEND}"

src_install() {
    local dest="${D}/opt/logstash"

    mkdir -p "${dest}"
    cp -R "${WORKDIR}/*" "${dest}/" || die
}
