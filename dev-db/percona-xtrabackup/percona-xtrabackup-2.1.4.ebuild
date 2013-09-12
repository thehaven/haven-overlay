# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Ebuild taken from: http://forums.gentoo.org/viewtopic-t-931984.html

EAPI=4

MY_PV="${PN}-${PV}"

DESCRIPTION="MySQL hot backup software."
HOMEPAGE="http://www.percona.com/software/percona-xtrabackup/"
SRC_URI="http://www.percona.com/redir/downloads/XtraBackup/XtraBackup-${PV}/source/${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mysql51 mysql51plugin mysql55 percona51 percona55 percona56"

DEPEND="dev-util/cmake
	dev-libs/libaio
	mysql51? ( sys-devel/automake:1.10 )
	mysql51plugin? ( sys-devel/automake:1.10 )
	percona51? ( sys-devel/automake:1.10 dev-vcs/bzr )
	percona55? ( dev-vcs/bzr )
	percona56? ( dev-vcs/bzr )"

S="${WORKDIR}/${MY_PV}"

pkg_setup() {
  if ! ( use mysql51 || use mysql51plugin || use mysql55 || use percona51 || use percona55 || use percona56 ); then
    die "Please select a target!"
  fi

  ewarn;ewarn;ewarn
  ewarn "Warning: please select a single target!"
  ewarn;ewarn;ewarn
  sleep 10
}

src_compile() {
  if use mysql51; then
	AUTO_DOWNLOAD="yes" ${S}/utils/build.sh innodb51_builtin
  fi
  
  if use mysql51plugin; then
	AUTO_DOWNLOAD="yes" ${S}/utils/build.sh innodb51
  fi

  if use mysql55; then
	AUTO_DOWNLOAD="yes" ${S}/utils/build.sh innodb55
  fi
  
  if use percona51; then
	AUTO_DOWNLOAD="yes" ${S}/utils/build.sh xtradb51
  fi
  
  if use percona55; then
	AUTO_DOWNLOAD="yes" ${S}/utils/build.sh xtradb55
  fi

  if use percona56; then
    AUTO_DOWNLOAD="yes" ${S}/utils/build.sh xtradb56
  fi

}

src_install() {	
	dobin innobackupex
	
	if use mysql51; then
	  dobin src/xtrabackup_51
	fi
	
	if use mysql51plugin; then
	  dobin src/xtrabackup_plugin
	fi
	
	if use mysql55; then
	  dobin src/xtrabackup_innodb55
	fi
	
	if use percona51; then
	  dobin src/xtrabackup
	fi
	
	if use percona55; then
	  dobin src/xtrabackup_55
	fi
	
    if use percona56; then
      dobin src/xtrabackup_56
    fi

	doman doc/xtrabackup.1
}

pkg_postinst() {
	elog "Percona xtrabackup installed. Use the following binaries:"
	elog "for MySQL 5.1 (builtin): xtrabackup_51" 
	elog "for MySQL 5.1 (plugin): xtrabackup_plugin"
	elog "for MySQL 5.5: xtrabackup_innodb55" 
	elog "for Percona XtraDB 5.1: xtrabackup" 
	elog "for Percona XtraDB 5.5: xtrabackup_55"
	elog "for Percona XtraDB 5.6: xtrabackup_56"
}
