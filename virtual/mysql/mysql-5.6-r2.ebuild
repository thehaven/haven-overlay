# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Virtual for MySQL client or database"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0/18"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="embedded minimal static static-libs"

DEPEND=""
# TODO: add Drizzle and MariaDB here
RDEPEND="|| (
       =dev-db/mariadb-10.0*[embedded=,minimal=,static=,static-libs=]
       =dev-db/mysql-${PV}*[embedded=,minimal=,static=,static-libs=]
       =dev-db/percona-${PV}*[embedded=]
	   =dev-db/percona-server-${PV}*[embedded=,minimal=,static=,static-libs=]
       =dev-db/mariadb-galera-10.0*[embedded=,minimal=,static=,static-libs=]
       =dev-db/mysql-cluster-7.3*[embedded=,minimal=,static=,static-libs=]
)"
