# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )

RUST_MIN_VER="1.82.0"


inherit cargo distutils-r1 multiprocessing optfeature systemd

DESCRIPTION="Reference implementation of Matrix homeserver"
HOMEPAGE="
	https://matrix.org/
	https://github.com/element-hq/synapse
"
SRC_URI="
	https://github.com/element-hq/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="|| ( AGPL-3+ Element-Commercial )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT Unicode-3.0
"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="ldap oidc postgres redis saml2 selinux systemd test workers"
RESTRICT="!test? ( test )"

# Fails to run with =prometheus-client-0.24, see upstream issue
# https://github.com/element-hq/synapse/issues/19375
RDEPEND="
	acct-user/synapse
	acct-group/synapse
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/bcrypt[${PYTHON_USEDEP}]
	dev-python/bleach[${PYTHON_USEDEP}]
	>=dev-python/canonicaljson-2[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ijson[${PYTHON_USEDEP}]
	dev-python/immutabledict[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.0[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	>=dev-python/matrix-common-1.3.0[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/netaddr[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/phonenumbers[${PYTHON_USEDEP}]
	>=dev-python/pillow-10.0.1[${PYTHON_USEDEP},webp]
	<dev-python/prometheus-client-0.24[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/pymacaroons[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	>=dev-python/python-multipart-0.0.12-r100[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/service-identity[${PYTHON_USEDEP}]
	dev-python/signedjson[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
	dev-python/treq[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/unpaddedbase64[${PYTHON_USEDEP}]
	postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
	selinux? ( sec-policy/selinux-matrixd )
	systemd? ( dev-python/python-systemd[${PYTHON_USEDEP}] )
"
BDEPEND="
	acct-user/synapse
	acct-group/synapse
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/hiredis[${PYTHON_USEDEP}]
		dev-python/idna[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/txredisapi[${PYTHON_USEDEP}]
		postgres? ( dev-db/postgresql[server] )
	)
"

# Rust extension
QA_FLAGS_IGNORED="usr/lib/python3.*/site-packages/synapse/synapse_rust.abi3.so"

src_test() {
	if use postgres; then
		einfo "Preparing postgres test instance"
		initdb --pgdata="${T}/pgsql" || die
		pg_ctl --wait --pgdata="${T}/pgsql" start \
			--options="-h '' -k '${T}'" || die
		createdb --host="${T}" synapse_test || die

		# See https://matrix-org.github.io/synapse/latest/development/contributing_guide.html#running-tests-under-postgresql
		local -x SYNAPSE_POSTGRES=1
		local -x SYNAPSE_POSTGRES_HOST="${T}"
	fi

	# This remove is necessary otherwise python is not able to locate
	# synapse_rust.abi3.so.
	rm -rf synapse || die

	nonfatal distutils-r1_src_test
	local ret=${?}

	if use postgres; then
		einfo "Stopping postgres test instance"
		pg_ctl --wait --pgdata="${T}/pgsql" stop || die
	fi

	[[ ${ret} -ne 0 ]] && die
}

python_test() {
	"${EPYTHON}" -m twisted.trial -j "$(makeopts_jobs)" tests
}

src_install() {
	distutils-r1_src_install
	keepdir /var/{lib,log}/synapse /etc/synapse
	fowners synapse:synapse /var/{lib,log}/synapse /etc/synapse
	fperms 0750 /var/{lib,log}/synapse /etc/synapse
	newinitd "${FILESDIR}/${PN}.initd-r1" "${PN}"
	systemd_dounit "${FILESDIR}/synapse.service"
}

pkg_postinst() {
	optfeature "Redis support" dev-python/txredisapi
	optfeature "VoIP relaying on your homeserver with turn" net-im/coturn

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		einfo
		elog "In order to generate initial configuration run:"
		elog "sudo -u synapse synapse_homeserver \\"
		elog "    --server-name matrix.domain.tld \\"
		elog "    --config-path /etc/synapse/homeserver.yaml \\"
		elog "    --generate-config \\"
		elog "    --data-directory /var/lib/synapse \\"
		elog "    --report-stats=no"
		einfo
	else
		einfo
		elog "Please refer to upgrade notes if any special steps are required"
		elog "to upgrade from the version you currently have installed:"
		elog
		elog "  https://github.com/element-hq/synapse/blob/develop/docs/upgrade.md"
		einfo
	fi
}
