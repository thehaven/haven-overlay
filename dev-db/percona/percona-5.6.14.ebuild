# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="Percona Server with XtraDB is a backwards-compatible replacement
for MySQL that is much faster and more scalable, easier to monitor and tune, and
has features to make operational tasks easier. It is designed to excel for cloud
computing, support NoSQL access, and take full advantage of modern hardware such
as SSD and Flash storage."
HOMEPAGE="http://www.percona.com/software/percona-server/"

MY_P="5.6"
MY_POINT="14"
MY_STABLE="rel"
MY_PATCH="62.0"
REVISION="483"

MY_PS="${MY_P}.${MY_POINT}-${MY_PATCH}"
MY_PV="${MY_P}.${MY_POINT}-${MY_STABLE}${MY_PATCH}"
MY_PN="Percona-Server-${MY_PV}.Linux.x86_64"
MY_S="Percona-Server-${MY_PV}"

# http://www.percona.com/redir/downloads/Percona-Server-5.6/Percona-Server-5.6.14-rel62.0/source/Percona-Server-5.6.14-rel62.0.tar.gz

#SRC_URI="amd64? ( http://www.percona.com/redir/downloads/Percona-Server-${MY_P}/Percona-Server-${MY_PV}/release-${MY_PS}/${REVISION}/source/Percona-Server-${MY_PV}.tar.gz )"
SRC_URI="amd64? ( http://www.percona.com/redir/downloads/Percona-Server-${MY_P}/Percona-Server-${MY_PV}/source/Percona-Server-${MY_PV}.tar.gz )"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64"
IUSE="embedded test"

DEPEND="!dev-db/mysql
		!dev-db/mariadb"
RDEPEND="${DEPEND}
		dev-db/mysql-init-scripts
		dev-libs/libaio
		>=sys-apps/openrc-0.7.0
		"

S=${WORKDIR}/${MY_S}
PERCONA_VER=${MY_PV}

src_configure() {
	# cmake -L lists the cache variables:
	# https://wikis.oracle.com/display/mysql/Autotools+to+CMake+Transition+Guide
	# Useful values listed by mysql-cmake:
	# http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/eclass/mysql-cmake.eclass
	mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr"
	    "-DMYSQL_DATADIR=${EPREFIX}/var/lib/mysql"
	    "-DSYSCONFDIR=${EPREFIX}/etc/mysql"
	    "-DINSTALL_BINDIR=bin"
	    "-DINSTALL_DOCDIR=share/doc/${P}"
	    "-DINSTALL_DOCREADMEDIR=share/doc/${P}"
	    "-DINSTALL_INCLUDEDIR=include/mysql"
        "-DINSTALL_INFODIR=share/info"
        "-DINSTALL_LIBDIR=$(get_libdir)/mysql"
        "-DINSTALL_MANDIR=share/man"
	    "-DINSTALL_MYSQLDATADIR=${EPREFIX}/var/lib/mysql"
	    "-DINSTALL_MYSQLSHAREDIR=share/mysql"
	    "-DINSTALL_MYSQLTESTDIR=share/mysql/mysql-test"
	    "-DINSTALL_PLUGINDIR=$(get_libdir)/mysql/plugin"
	    "-DINSTALL_SBINDIR=sbin"
	    "-DINSTALL_SCRIPTDIR=share/mysql/scripts"
	    "-DINSTALL_SQLBENCHDIR=share/mysql"
	    "-DINSTALL_SUPPORTFILESDIR=${EPREFIX}/usr/share/mysql"
	    "-DWITH_COMMENT=\"Gentoo Linux ${PF}\""
		"-DCMAKE_BUILD_TYPE=RelWithDebInfo"
		"-DBUILD_CONFIG=mysql_release"
		"-DFEATURE_SET=community"
		"$(cmake-utils_use_with embedded EMBEDDED_SERVER)"
		"$(cmake-utils_use_with test UNIT_TESTS)"
	)
	cmake-utils_src_configure
}

src_install() {

		cmake-utils_src_install

		# Convenience links
		einfo "Making Convenience links for mysqlcheck multi-call binary"
		dosym "/usr/bin/mysqlcheck" "/usr/bin/mysqlanalyze"
		dosym "/usr/bin/mysqlcheck" "/usr/bin/mysqlrepair"
		dosym "/usr/bin/mysqlcheck" "/usr/bin/mysqloptimize"

		cat <<-EOF > "${T}"/80mysql-libdir
		LDPATH="${EPREFIX}/usr/$(get_libdir)/mysql"
		EOF
		doenvd "${T}"/80mysql-libdir
}

pkg_postinst() {
        insinto /etc/conf.d/
        newins ${FILESDIR}/conf.d.mysql mysql

        exeinto /etc/init.d/
        newexe ${FILESDIR}/init.d.mysql mysql

		einfo "A few config options have changed in 5.6 so its worth running:"
		einfo "mysqld --verbose --defaults-file=/etc/mysql/my.cnf"
		einfo "And checking it starts without backgrounding before setting up the init."
}
