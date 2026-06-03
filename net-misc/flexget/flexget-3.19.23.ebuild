# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14})

DISTUTILS_USE_PEP517=setuptools
PYPI_PN="FlexGet"
inherit distutils-r1 pypi

DESCRIPTION="Multipurpose automation tool for content like torrents, nzbs, podcasts, comics"
HOMEPAGE="http://flexget.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test transmission"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/feedparser-5.2.1[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.0.9[${PYTHON_USEDEP}]
	<dev-python/sqlalchemy-1.999[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-4.5:4[${PYTHON_USEDEP}]
	>=dev-python/html5lib-0.11[${PYTHON_USEDEP}]
	dev-python/PyRSS2Gen[${PYTHON_USEDEP}]
	dev-python/pynzb[${PYTHON_USEDEP}]
	dev-python/rpyc[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/requests-2.8.0[${PYTHON_USEDEP}]
	<dev-python/requests-3[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.5.3[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0[${PYTHON_USEDEP}]
	>=dev-python/path-py-8.1.1[${PYTHON_USEDEP}]
	>=dev-python/pathlib-1.0[${PYTHON_USEDEP}]
	virtual/python-pathlib[${PYTHON_USEDEP}]
	<=dev-python/guessit-2.0.4[${PYTHON_USEDEP}]
	>=dev-python/cherrypy-3.7.0[${PYTHON_USEDEP}]
	>=dev-python/APScheduler-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/flask-0.7[${PYTHON_USEDEP}]
	>=dev-python/flask-restful-0.3.3[${PYTHON_USEDEP}]
	=dev-python/flask-restplus-0.8.6[${PYTHON_USEDEP}]
	>=dev-python/flask-compress-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/flask-login-0.4[${PYTHON_USEDEP}]
	>=dev-python/flask-cors-2.1.2[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.0.3[${PYTHON_USEDEP}]
	>=dev-python/Safe-0.4[${PYTHON_USEDEP}]
	>=dev-python/future-0.15.2[${PYTHON_USEDEP}]
	>=dev-python/colorclass-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/terminaltables-3.1.0[${PYTHON_USEDEP}]
	dev-python/zxcvbn-python[${PYTHON_USEDEP}]
	"
RDEPEND="${DEPEND}
	transmission? ( dev-python/transmissionrpc[${PYTHON_USEDEP}] )
"
DEPEND+=" test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_test() {
	cp -lr tests setup.cfg "${BUILD_DIR}" || die
	run_in_build_dir nosetests -v --attr=!online > "${T}/tests-${EPYTHON}.log" \
		|| die "Tests fail with ${EPYTHON}"
}
