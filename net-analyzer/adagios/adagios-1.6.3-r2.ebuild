# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils git-r3

DESCRIPTION="Web based Nagios configuration interface"
HOMEPAGE="http://adagios.org/"
EGIT_REPO_URI="https://github.com/opinkerfi/adagios.git"
REVISION=${PR/r/-}
EGIT_COMMIT=${P}${REVISION}

LICENSE=""
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""

DEPEND="<dev-python/django-1.5
		net-analyzer/okconfig
		net-analyzer/pynag
		net-analyzer/pnp4nagios
		net-analyzer/mk-livestatus"
RDEPEND="${DEPEND}"

pkg_postinst() {
	elog "Run the following to setup adagios:"
	elog ""
	elog "mkdir -p /etc/nagios/adagios"
	elog "pynag config --append cfg_dir=/etc/nagios/adagios"
	elog ""
	elog "Add: cfg_dir=/etc/nagios/adagios to nagios.cfg to pull any created files in from adagios"
	elog ""
	elog "If you want to play with the experimental status view:"
	elog "pynag config --append \"broker_module=/usr/lib64/npcdmod.o config_file=/etc/pnp/npcd.cfg\""
	elog "pynag config --append \"broker_module=/usr/lib64/mk-livestatus/livestatus.o /var/nagios/rw/live\""
	elog "pynag config --set \"process_performance_data=1\""
	elog ""
	elog "For more information read the docs:"
	elog "http://adagios.org/"

    # Create a symlink pointing to the default configs:
    if [ ! -f /etc/adagios ]; then ln -s /usr/lib64/python2.7/site-packages/adagios/etc/adagios /etc/adagios; fi
}
