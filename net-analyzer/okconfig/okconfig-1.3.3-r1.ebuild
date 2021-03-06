# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils git-r3

DESCRIPTION="Ready made monitoring packs for Nagios"
HOMEPAGE="http://okconfig.org/"
EGIT_REPO_URI="https://github.com/opinkerfi/okconfig.git"
REVISION=${PR/r/-}
EGIT_COMMIT=${P}${REVISION}

LICENSE=""
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="+adagios"

DEPEND="dev-python/paramiko
		net-analyzer/nagios
		>net-analyzer/pynag-0.4.6"
RDEPEND="${DEPEND}
		net-analyzer/fping[suid]
		net-analyzer/traceroute
		net-analyzer/nagios-plugins-opinkerfi
"

pkg_postinst() {
    elog "Run the following to setup okconfig:"
    elog ""
	elog "okconfig init"
	elog "okconfig verify"
	elog
	if use adagios; then
	  insinto /etc/
	  newins ${FILESDIR}/okconfig.cfg okconfig.cfg || die
	  if [ ! -d "/etc/nagios/okconfig" ]; then 
	    okconfig init
	    okconfig verify
	  fi
	  if [ ! -d "/etc/nagios/okconfig/examples" ]; then mkdir /etc/nagios/okconfig/examples; fi
	  chown -Rf nobody:nagios /etc/nagios/okconfig
	  chmod -R g+rwX /etc/nagios/okconfig
	fi
	elog "In order to use the network scan feature of okconfig you will need to symlink fping so a non-root user can see it:"
	elog "ln -s /usr/sbin/fping /usr/bin/fping"
	elog "Alternatively alter your PATH variable for the user running okconfig"
}
