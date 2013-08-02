# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 git-2

DESCRIPTION="Enterprise scalable realtime graphing"
HOMEPAGE="http://graphite.wikidot.com/"
EGIT_REPO_URI="https://github.com/graphite-project/graphite-web.git"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
IUSE="uwsgi"

DEPEND="uwsgi? ( www-servers/uwsgi )"
RDEPEND="${DEPEND}
	dev-python/carbon[${PYTHON_USEDEP}]
	dev-python/ceres
	dev-python/django[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pytz
	dev-python/twisted
	dev-python/whisper[${PYTHON_USEDEP}]"

pkg_postinst() {
	if use uwsgi ; then
		insinto /etc/conf.d
		doins ${FILESDIR}/uwsgi/uwsgi.graphite
		insinto /etc/uwsgi.d/
		doins ${FILESDIR}/uwsgi/graphite.ini
		dosym /etc/init.d/uwsgi /etc/init.d/uwsgi.graphite
		elog "Start graphite-web via uwsgi using /etc/init.d/uwsgi.graphite"
		elog "Add to default runlevel via: rc-update add uwsgi.graphite"
	fi

	# Create symlink to config dir:
	dosym /opt/graphite/conf /etc/graphite
	elog "View configs in /etc/graphite and ensure a legit (non-sample) copy of each config file exists before starting graphite"
	elog "Once the configs are in order run:"
	elog "cd /opt/graphite/webapp/graphite && python ./manage.py syncdb"
}
