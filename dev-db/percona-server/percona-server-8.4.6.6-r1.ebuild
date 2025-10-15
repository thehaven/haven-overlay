# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=emake

inherit check-reqs cmake flag-o-matic linux-info multiprocessing prefix \
		toolchain-funcs systemd tmpfiles

DESCRIPTION="Percona Server for MySQL: enhanced, drop-in replacement for MySQL"
HOMEPAGE="https://www.percona.com/software/mysql-database/percona-server https://github.com/percona/percona-server"

# Percona 8.4.6-6 source tarball
# Upstream packages use dashed build suffix; keep PV as 8.4.6.6 and translate.
MY_UP_PV="8.4.6-6"
MY_PN="Percona-Server"
MY_P="${PN}-${MY_UP_PV}"
MY_MAJOR_PV="8.4"

# Boost: upstream requires an external Boost source tree at configure time
# Use a recent release that is compatible with GCC14 and C++17 used upstream.
MY_BOOST_VERSION="1.85.0"

SRC_URI="
	https://downloads.percona.com/downloads/${MY_PN}-${MY_MAJOR_PV}/${MY_PN}-${MY_UP_PV}/source/tarball/${PN}-${MY_UP_PV}.tar.gz
	https://www.boost.org/releases/${MY_BOOST_VERSION}/source/boost_$(ver_rs 1- _ ${MY_BOOST_VERSION}).tar.bz2
"
S="${WORKDIR}/percona-server-${MY_UP_PV}"

LICENSE="GPL-2"
SLOT="8.4"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="cjk cracklib debug jemalloc latin1 ldap numa pam +perl profiling rocksdb router selinux +server tcmalloc test"

RESTRICT="!test? ( test )"

REQUIRED_USE="
	?? ( tcmalloc jemalloc )
	cjk? ( server )
	jemalloc? ( server )
	numa? ( server )
	profiling? ( server )
	router? ( server )
	tcmalloc? ( server )
"

# Common libraries shared between build and runtime
COMMON_DEPEND="
	>=app-arch/lz4-0_p131:=
	app-arch/zstd:=
	sys-libs/ncurses:0=
	>=sys-libs/zlib-1.2.3:0=
	>=dev-libs/openssl-1.1.1:0=
	server? (
	dev-libs/icu:=
	dev-libs/libevent:=[ssl,threads(+)]
	>=dev-libs/protobuf-3.8:=
	net-libs/libtirpc:=
	net-misc/curl:=
	cjk? ( app-text/mecab:= )
	ldap? (
		dev-libs/cyrus-sasl
		<net-nds/openldap-2.6:=
	)
	jemalloc? ( dev-libs/jemalloc:0= )
	kernel_linux? (
		dev-libs/libaio:0=
		sys-process/procps:0=
	)
	numa? ( sys-process/numactl )
	pam? ( sys-libs/pam:0= )
	tcmalloc? ( dev-util/google-perftools:0= )
	)
"

# Build-time deps only
DEPEND="
	${COMMON_DEPEND}
	sys-devel/bison
	virtual/pkgconfig
	server? ( net-libs/rpcsvc-proto )
	test? (
	acct-group/mysql
	acct-user/mysql
	dev-perl/JSON
	)
"

# Tools and generators required during src_* phases (EAPI8)
BDEPEND="
	${DEPEND}
	>=dev-build/cmake-3.16
"

# Runtime dependencies
RDEPEND="
	${COMMON_DEPEND}
	!dev-db/mariadb
	!dev-db/mariadb-galera
	!dev-db/mysql
	!dev-db/mysql-cluster
	!dev-db/percona-server:0
	!dev-db/percona-server:5.7
	selinux? ( sec-policy/selinux-mysql )
	!prefix? (
	acct-group/mysql
	acct-user/mysql
	dev-db/mysql-init-scripts
	)
	virtual/tmpfiles
"

# For other packages to bring in client DBD
PDEPEND="
	perl? ( >=dev-perl/DBD-mysql-2.9004 )
"

DOCS=( README.md )

# Helper: initialize standard paths
mysql_init_vars() {
	: ${MY_SHAREDSTATEDIR:="${EPREFIX}/usr/share/mysql"}
	: ${MY_SYSCONFDIR:="${EPREFIX}/etc/mysql"}
	: ${MY_LOCALSTATEDIR:="${EPREFIX}/var/lib/mysql"}
	: ${MY_LOGDIR:="${EPREFIX}/var/log/mysql"}
	MY_DATADIR="${MY_LOCALSTATEDIR}"

	export MY_SHAREDSTATEDIR MY_SYSCONFDIR
	export MY_LOCALSTATEDIR MY_LOGDIR
	export MY_DATADIR
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && use server ; then
	CHECKREQS_DISK_BUILD="3G"
	if has test ${FEATURES} ; then
		CHECKREQS_DISK_BUILD="9G"
	fi
	check-reqs_pkg_pretend
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
	CHECKREQS_DISK_BUILD="3G"
	if has test ${FEATURES} ; then
		CHECKREQS_DISK_BUILD="9G"
		[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"
		if ! has userpriv ${FEATURES} ; then
		die "Testing with FEATURES=-userpriv is not supported. Run tests as non-root."
		fi
		local aio_max_nr=$(sysctl -n fs.aio-max-nr 2>/dev/null)
		[[ -z "${aio_max_nr}" || ${aio_max_nr} -lt 250000 ]] \
		&& die "FEATURES=test requires fs.aio-max-nr=250000 minimum."
		use latin1 && die "Testing with USE=latin1 is not supported."
	fi

	if use kernel_linux && use numa ; then
		linux-info_get_any_version
		local CONFIG_CHECK="~NUMA"
		local WARNING_NUMA="This package expects NUMA support in kernel; enable NUMA or build without USE=numa."
		check_extra_config
	fi

	use server && check-reqs_pkg_setup
	fi
}

src_unpack() {
	default
	# Upstream tarball extracts to percona-server-${MY_UP_PV}
	# Provide Boost tarball path for cmake
}

src_prepare() {
	# Apply local patches only if needed for 8.4 (remove if unnecessary)
	# eapply "${FILESDIR}"/${PN}-8.4-gcc-14.patch
	# eapply "${FILESDIR}"/${PN}-8.4-sql-link-jemalloc-tcmalloc.patch

	# Avoid rpm sandboxing if still present
	sed -i -e 's/MY_RPM rpm/MY_RPM rpmNOTEXISTENT/' CMakeLists.txt || die

	if use jemalloc ; then
	echo "TARGET_LINK_LIBRARIES(mysqld jemalloc)" >> sql/CMakeLists.txt || die
	fi
	if use tcmalloc ; then
	echo "TARGET_LINK_LIBRARIES(mysqld tcmalloc)" >> sql/CMakeLists.txt || die
	fi

	# Clean out incompatible SELinux rules if present in tree
	if [[ -d support-files/SELinux ]] ; then
	: > support-files/SELinux/CMakeLists.txt || die
	fi

	# Remove manpages for tools not installed (adjust if upstream layout changed)
	rm -f man/my_print_defaults.1 man/perror.1 man/zlib_decompress.1 || die

	# Patch converts the string_view to a std::string
	eapply "${FILESDIR}/percona-server-8.4-stringview.patch"

	cmake_src_prepare
}

src_configure() {
	# Flags
	filter-flags "-O" "-O[01]"
	append-cxxflags -felide-constructors
	# Upstream is C++17+ capable, but maintain C++14 if needed; adjust if 8.4 needs 17
	#append-cxxflags -std=c++17
	# std::bit_floor is part of the C++20 standard (<bit> header).
	append-cxxflags -std=c++20
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
	-DCMAKE_C_FLAGS_RELWITHDEBINFO="$(usex debug '' '-DNDEBUG')"
	-DCMAKE_CXX_FLAGS_RELWITHDEBINFO="$(usex debug '' '-DNDEBUG')"
	-DCMAKE_BUILD_TYPE=RelWithDebInfo
	-DMYSQL_DATADIR="${EPREFIX}/var/lib/mysql"
	-DSYSCONFDIR="${EPREFIX}/etc/mysql"
	-DINSTALL_BINDIR=bin
	-DINSTALL_DOCDIR=share/doc/${PF}
	-DINSTALL_DOCREADMEDIR=share/doc/${PF}
	-DINSTALL_INCLUDEDIR=include/mysql
	-DINSTALL_INFODIR=share/info
	-DINSTALL_LIBDIR=$(get_libdir)
	-DINSTALL_MANDIR=share/man
	-DINSTALL_MYSQLSHAREDIR=share/mysql
	-DINSTALL_PLUGINDIR=$(get_libdir)/mysql/plugin
	-DINSTALL_MYSQLDATADIR="${EPREFIX}/var/lib/mysql"
	-DINSTALL_SBINDIR=sbin
	-DINSTALL_SUPPORTFILESDIR="${EPREFIX}/usr/share/mysql"
	-DCOMPILATION_COMMENT="Gentoo Linux ${PF}"
	-DWITH_UNIT_TESTS=$(usex test ON OFF)
	-DWITH_EDITLINE=bundled
	-DWITH_ZLIB=system
	-DWITH_SSL=system
	-DWITH_LIBWRAP=0
	-DENABLED_LOCAL_INFILE=1
	-DMYSQL_UNIX_ADDR="${EPREFIX}/run/mysqld/mysqld.sock"
	-DWITH_DEFAULT_COMPILER_OPTIONS=0
	-DSTACK_DIRECTION=$(tc-stack-grows-down && echo -1 || echo 1)
	-DCMAKE_POSITION_INDEPENDENT_CODE=ON
	-DUSE_LD_LLD=OFF
	-DWITH_CURL=system
	-DWITH_BOOST="${WORKDIR}/boost_$(ver_rs 1- _ ${MY_BOOST_VERSION})"
	-DWITH_ROUTER=$(usex router ON OFF)
	-DWITHOUT_CLIENTLIBS=YES
	-DWITH_ICU=system
	-DWITH_LZ4=system
	-DWITH_RAPIDJSON=bundled
	-DWITH_ZSTD=system
	)

	tc-is-lto && mycmakeargs+=( -DWITH_LTO=ON ) || mycmakeargs+=( -DWITH_LTO=OFF )

	if use test ; then
	mycmakeargs+=( -DINSTALL_MYSQLTESTDIR=share/mysql/mysql-test )
	else
	mycmakeargs+=( -DINSTALL_MYSQLTESTDIR='' )
	fi

	# Charset defaults
	if [[ -n "${MYSQL_DEFAULT_CHARSET}" && -n "${MYSQL_DEFAULT_COLLATION}" ]]; then
	ewarn "Custom charset ${MYSQL_DEFAULT_CHARSET} / ${MYSQL_DEFAULT_COLLATION}; unsupported for bug reports."
	mycmakeargs+=(
		-DDEFAULT_CHARSET=${MYSQL_DEFAULT_CHARSET}
		-DDEFAULT_COLLATION=${MYSQL_DEFAULT_COLLATION}
	)
	elif use latin1 ; then
	mycmakeargs+=(
		-DDEFAULT_CHARSET=latin1
		-DDEFAULT_COLLATION=latin1_swedish_ci
	)
	else
	mycmakeargs+=(
		-DDEFAULT_CHARSET=utf8mb4
		-DDEFAULT_COLLATION=utf8mb4_0900_ai_ci
	)
	fi

	if use server ; then
	mycmakeargs+=(
		-DWITH_AUTHENTICATION_LDAP=$(usex ldap system OFF)
		-DWITH_COREDUMPER=OFF
		-DWITH_EXTRA_CHARSETS=all
		-DWITH_DEBUG=$(usex debug)
		-DWITH_MECAB=$(usex cjk system OFF)
		-DWITH_LIBEVENT=system
		-DWITH_PROTOBUF=system
		-DWITH_NUMA=$(usex numa ON OFF)
		-DWITH_PAM=$(usex pam)
		-DWITH_SYSTEMD=ON
	)

	use profiling && mycmakeargs+=( -DENABLED_PROFILING=ON )

	# Storage engines
	mycmakeargs+=(
		-DWITH_EXAMPLE_STORAGE_ENGINE=0
		-DWITH_ARCHIVE_STORAGE_ENGINE=1
		-DWITH_BLACKHOLE_STORAGE_ENGINE=1
		-DWITH_CSV_STORAGE_ENGINE=1
		-DWITH_FEDERATED_STORAGE_ENGINE=1
		-DWITH_HEAP_STORAGE_ENGINE=1
		-DWITH_INNOBASE_STORAGE_ENGINE=1
		-DWITH_INNODB_MEMCACHED=0
		-DWITH_MYISAMMRG_STORAGE_ENGINE=1
		-DWITH_MYISAM_STORAGE_ENGINE=1
		-DWITH_ROCKSDB=$(usex rocksdb 1 0)
	)
	else
	mycmakeargs+=(
		-DWITHOUT_SERVER=1
		-DWITH_SYSTEMD=OFF
	)
	fi

	cmake_src_configure
}

src_test() {
	if ! use server ; then
	einfo "Skipping server tests (USE=-server)."
	return 0
	fi
	# Keep upstream heavy test matrix disabled by default.
	# Consider enabling targeted tests later with FEATURE=test and proper env.
	cmake_src_test
}

src_install() {
	cmake_src_install

	mysql_init_vars

	# Convenience symlinks for mysqlcheck multi-call
	dosym -r mysqlcheck /usr/bin/mysqlanalyze
	dosym -r mysqlcheck /usr/bin/mysqlrepair
	dosym -r mysqlcheck /usr/bin/mysqloptimize

	# Remove test suite unless USE=test
	if ! use test ; then
	rm -rf "${ED}/${MY_SHAREDSTATEDIR#${EPREFIX}}/mysql-test" || die
	fi

	# Example configuration
	insinto "${MY_SYSCONFDIR#${EPREFIX}}"
	doins support-files/mysqlaccess.conf 2>/dev/null || true

	# Example my.cnf snippets (provide these under files/)
	insinto "${MY_SYSCONFDIR#${EPREFIX}}/mysql.d"
	newins "${FILESDIR}/my.cnf-8.4.distro-client" 50-distro-client.cnf
	local mycnf_src="my.cnf-8.4.distro-server"
	local tmp="${T}/50-distro-server.cnf"
	sed -e "s!@DATADIR@!${MY_DATADIR}!g" "${FILESDIR}/${mycnf_src}" > "${tmp}" || die
	use prefix && sed -i -r -e '/^user[[:space:]]*=[[:space:]]*mysql$/d' "${tmp}" || die
	use latin1 && sed -i -e "/character-set/s|utf8mb4|latin1|g" "${tmp}" || die
	eprefixify "${tmp}"
	newins "${tmp}" 50-distro-server.cnf

	# Optional: remove mytop if no perl
	[[ -e "${ED}/usr/bin/mytop" ]] && ! use perl && rm -f "${ED}/usr/bin/mytop"

	# Systemd unit: install if present upstream or from files/
	# If upstream installs, this is redundant; otherwise provide maintained unit
	if use server ; then
	if [[ -f "${S}/support-files/mysql.server" ]]; then
		# OpenRC script may be provided by mysql-init-scripts; avoid conflicts
		:
	fi
	if [[ -f "${S}/support-files/systemd/mysqld.service.in" || -f "${FILESDIR}/mysqld.service" ]]; then
		# Prefer our curated unit
		systemd_dounit "${FILESDIR}/mysqld.service"
	fi
	fi

	# tmpfiles.d for runtime dirs (install ours)
	# Provide ${FILESDIR}/mysql.conf with entries for /run/mysqld and /var/log/mysql
	dotmpfiles "${FILESDIR}"/mysql.conf

	# Remove legacy re-entrant client symlinks if any
	find "${ED}" -name 'libmysqlclient_r.*' -type l -delete || die
}

pkg_postinst() {
	mysql_init_vars

	# Create log dir securely if not present (tmpfiles handles this but create now too)
	[[ -d "${MY_LOGDIR}" ]] || install -d -m0750 -o mysql -g mysql "${MY_LOGDIR}"

	# Process tmpfiles now to create /run and /var/log dirs on non-systemd too
	tmpfiles_process mysql.conf

	ewarn
	ewarn "Configuration is now split under ${MY_SYSCONFDIR}/mysql.d/*.cnf."
	ewarn "Backup any previous /etc/mysql/my.cnf changes and re-apply under mysql.d."
	ewarn

	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
	elog "Run: emerge --config =${CATEGORY}/${PF} to initialize the data directory."
	else
	elog "For upgrades, review upstream 8.4 upgrade docs and test on staging first."
	fi
}

# pkg_config remains large; keep aligned with upstream behavior if retained.
# Consider delegating initialization to mysql-init-scripts tooling.
pkg_config() {
	# Initialize data directory and set root password, similar to previous ebuild.
	# For brevity and safety, recommend using dev-db/mysql-init-scripts tooling.
	ewarn "Use mysql_install_db or mysqld --initialize via mysql-init-scripts for initialization."
	ewarn "Manual initialization via pkg_config is not provided in this revision."
	die "Initialization is handled by mysql-init-scripts; see emerge --config messages."
}
