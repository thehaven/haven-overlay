# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1 systemd tmpfiles

DESCRIPTION="Reference Push Gateway for Matrix"
HOMEPAGE="https://github.com/matrix-org/sygnal"
SRC_URI="https://github.com/matrix-org/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="apns fcm"

RDEPEND="
	acct-user/sygnal
	acct-group/sygnal
	>=dev-python/twisted-21.2.0[${PYTHON_USEDEP}]
	>=dev-python/prometheus-client-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/aioapns-2.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/opentracing-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/sentry-sdk-0.14.3[${PYTHON_USEDEP}]
	>=dev-python/matrix-common-1.0.0[${PYTHON_USEDEP}]
	apns? ( >=dev-python/pyjwt-2.0.0[${PYTHON_USEDEP}] )
	fcm? ( >=dev-python/firebase-admin-5.0.0[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/treq[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	dotmpfiles "${FILESDIR}"/${PN}.tmpfiles
}
