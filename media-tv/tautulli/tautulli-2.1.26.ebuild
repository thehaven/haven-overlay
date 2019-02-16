# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='sqlite(+)'

inherit python-single-r1 systemd

DESCRIPTION="A python based web application for monitoring your Plex Media Server."
HOMEPAGE="https://github.com/Tautulli/Tautulli"
SRC_URI="https://github.com/Tautulli/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S=${WORKDIR}/Tautulli-${PV}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="**"
IUSE=""

RDEPEND="
	dev-python/pyopenssl
	${DEPEND}
"
DEPEND="
	${PYTHON_DEPS}
"

src_install() {
	dodoc API.md CHANGELOG.md CONTRIBUTING.md ISSUE_TEMPLATE.md README.md
	dodir /opt/${PN}/
	cp -R contrib data lib plexpy pylintrc PlexPy.py Tautulli.py "${D}/opt/${PN}" || die
	dodir /etc/${PN}
	dosym  /opt/${PN}/config.ini /etc/${PN}/config.ini
	fowners -R plex:plex "/opt/${PN}"

	systemd_dounit  "${FILESDIR}"/${PN}.service
	newinitd "${FILESDIR}/${PN}.init" ${PN}
}
