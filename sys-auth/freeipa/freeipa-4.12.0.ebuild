# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit autotools python-single-r1 systemd

DESCRIPTION="Integrated Identity and Authentication solution for Linux/UNIX"
HOMEPAGE="https://www.freeipa.org/"
SRC_URI="https://github.com/freeipa/freeipa/archive/refs/tags/release-${PV//./-}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="server client"
REQUIRED_USE="server? ( client ) ${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	server? (
		>=net-nds/389-ds-base-2.4
		>=net-dns/bind-9.16[dlz]
		net-dns/bind-dyndb-ldap
		>=app-crypt/mit-krb5-1.20[pkinit]
		app-crypt/pki-core
		net-nds/slapi-nis
		net-fs/samba
		sys-auth/sssd[samba]
		www-apache/mod_lookup_identity
		www-apache/mod_auth_gssapi
		$(python_gen_cond_dep '
			dev-python/kdcproxy[${PYTHON_USEDEP}]
		')
	)
	client? (
		sys-auth/sssd
		>=app-crypt/mit-krb5-1.20
	)
	$(python_gen_cond_dep '
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/python-ldap[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/gssapi[${PYTHON_USEDEP}]
		dev-python/netaddr[${PYTHON_USEDEP}]
		dev-python/pyasn1[${PYTHON_USEDEP}]
		dev-python/qrcode[${PYTHON_USEDEP}]
	')
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(use_with server)
		$(use_with client)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}
