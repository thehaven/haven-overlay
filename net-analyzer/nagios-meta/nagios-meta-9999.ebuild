# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Nagios meta build for pulling in all the nagios dependancies in one
shot, heavily influenced by OMD"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-vim/nagios-syntax
		net-analyzer/adagios
		net-analyzer/mk-livestatus
		net-analyzer/nagios
		net-analyzer/nagios-check_logfiles
		net-analyzer/nagios-check_multi
		net-analyzer/nagios-check_mysql_health
		net-analyzer/nagios-plugins
		net-analyzer/nagios-plugins-snmp
		net-analyzer/nagvis
		net-analyzer/nrpe
		net-analyzer/pnp4nagios"
RDEPEND="${DEPEND}"

