# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

PYTHON_COMPAT=( python3_{6..10} )

EGIT_REPO_URI="https://gitlab.com/LazyLibrarian/LazyLibrarian.git"

inherit eutils user git-r3 python-r1

DESCRIPTION="LazyLibrarian is an automated book downloader for SABnzbd."
HOMEPAGE="http://github.com/DobyTang/LazyLibrarian"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
		dev-python/apprise[${PYTHON_USEDEP}]
		dev-python/cherrypy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/python-levenshtein[${PYTHON_USEDEP}]
		dev-python/unidecode[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
		app-arch/unrar
		app-misc/jq
		app-text/ghostscript-gpl
		media-libs/libjpeg-turbo
		sys-libs/zlib"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_install() {
	dodoc README.md

	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	keepdir /var/${PN}
	fowners -R ${PN}:${PN} /var/${PN}

	keepdir /var/{${PN}/{cache,download},log/${PN}}
	fowners -R ${PN}:${PN} /var/{${PN}/{cache,download},log/${PN}}

	insinto /etc/${PN}
	insopts -m0660 -o ${PN} -g ${PN}
	doins "${FILESDIR}/${PN}.ini"

	# Rotation of log files
	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	# wierd stuff ;-)
	last_commit=$(git rev-parse HEAD)
	echo ${last_commit} > version.txt

	insinto /usr/share/${PN}
	doins -r cherrypy data lazylibrarian lib lib3 mako LazyLibrarian.py version.txt
	fowners ${PN}:${PN} /usr/share/${PN}/version.txt
}

pkg_postinst() {

	# we need to remove .git which old ebuild installed
	if [[ -d "/usr/share/${PN}/.git" ]] ; then
	   ewarn "stale files from previous ebuild detected"
	   ewarn "/usr/share/${PN}/.git removed."
	   ewarn "To ensure proper operation, you should unmerge package and remove directory /usr/share/${PN} and then emerge package again"
	   ewarn "Sorry for the inconvenience"
	   rm -Rf "/usr/share/${PN}/.git"
	fi

	#python_mod_optimize /usr/share/${PN}

	elog "${PN} has been installed with data directories in /var/${PN}"
	elog
	elog "New user/group ${PN}/${PN} has been created"
	elog
	elog "Config file is located in /etc/${PN}/${PN}.ini"
	elog
	elog "Please configure /etc/conf.d/${PN} before starting as daemon!"
	elog
	elog "Start with ${ROOT}etc/init.d/${PN} start"
	elog "Visit http://<host ip>:8092 to configure ${PN}"
	elog "Default web username/password : lazylibrarian/secret"
	elog
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
