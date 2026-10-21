# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 systemd git-r3 optfeature

DESCRIPTION="A simple CalDAV calendar server"
HOMEPAGE="https://radicale.org/"

# Live ebuild: tracks the upstream master branch (currently 3.9.0.dev).
# Tagged releases are available from ::gentoo (www-apps/radicale-3.7.7).
EGIT_REPO_URI="https://github.com/Kozea/Radicale.git"

MY_PN="radicale"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"

# Live ebuilds carry no testing keywords.
KEYWORDS=""

# bcrypt hashes for the htpasswd authentication backend (upstream extra).
IUSE="bcrypt"

# Upstream runtime dependencies (pyproject.toml):
#   defusedxml, libpass>=1.9.3, vobject>=0.9.6, pika>=1.1.0, requests
#
# libpass is the maintained fork of passlib (the Python module is still
# imported as "passlib"). dev-python/passlib no longer exists in ::gentoo,
# so the old dep made this ebuild impossible to satisfy.
RDEPEND="
	>=acct-user/radicale-0-r2
	acct-group/radicale
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/libpass[${PYTHON_USEDEP}]
	dev-python/pika[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/vobject[${PYTHON_USEDEP}]
	sys-apps/util-linux
	bcrypt? ( dev-python/bcrypt[${PYTHON_USEDEP}] )
"

BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/waitress[${PYTHON_USEDEP}]
	)
"

PROPERTIES="live"

RDIR=/var/lib/"${PN}"

DOCS=( DOCUMENTATION.md CHANGELOG.md README.md )

distutils_enable_tests pytest

python_test() {
	epytest -o addopts= radicale/tests/
}

python_install_all() {
	newinitd "${FILESDIR}"/radicale-r3.init.d radicale

	# Upstream dropped the --foreground flag, so the unit must not pass it.
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir "${RDIR}"
	fperms 0750 "${RDIR}"
	fowners "${PN}:${PN}" "${RDIR}"

	insinto /etc/"${PN}"
	doins config

	exeinto /usr/share/"${PN}"
	doexe radicale.wsgi

	distutils-r1_python_install_all
}

pkg_postinst() {
	local _erdir="${EROOT}${RDIR}"

	ewarn ""
	ewarn "Since 3.5.0 the default [auth] type is \"denyall\"."
	ewarn "Set the auth type you want in ${EROOT}/etc/${PN}/config,"
	ewarn "otherwise the server refuses every request."
	ewarn ""

	einfo "A sample WSGI script has been put into ${EROOT}/usr/share/${PN}."
	einfo "You will also find an example FastCGI script."

	# Upstream extras that are not exposed as USE flags.
	optfeature "argon2 password hashing" dev-python/argon2-cffi
	optfeature "LDAP/LDAPS authentication" dev-python/ldap3 "dev-python/python-ldap"

	if [[ -d ${_erdir} ]] && [[ $(stat --format="%U:%G:%a" "${_erdir}") != "${PN}:${PN}:750" ]]; then
		ewarn ""
		ewarn "Unsafe file permissions detected on ${_erdir}."
		ewarn "To fix run:"
		ewarn "# \`chown -R ${PN}:${PN} ${_erdir}\`"
		ewarn "# \`chmod 0750 ${_erdir}\`"
		ewarn "# \`chmod -R o= ${_erdir}\`"
		ewarn ""
	fi
}
