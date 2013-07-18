# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit distutils eutils git-2

DESCRIPTION="Web based Nagios configuration interface"
HOMEPAGE="http://adagios.org/"
EGIT_REPO_URI="https://github.com/opinkerfi/adagios.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-analyzer/okconfig
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
    elog "pynag config --append \"broker_module=/usr/lib64/nagios/brokers/npcdmod.o config_file=/etc/pnp4nagios/npcd.cfg\""
    elog "pynag config --append \"broker_module=/usr/lib64/mk-livestatus/livestatus.o /var/spool/nagios/cmd/livestatus\""
    elog "pynag config --set \"process_performance_data=1\""
    elog ""
    elog "For more information read the docs:"
    elog "http://adagios.org/"
}
