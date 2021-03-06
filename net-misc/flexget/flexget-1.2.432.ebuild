# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

if [[ ${PV} != 9999 ]]; then
	MY_P="FlexGet-${PV}"
	SRC_URI="mirror://pypi/F/FlexGet/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="git://github.com/Flexget/Flexget.git
		https://github.com/Flexget/Flexget.git"
fi

DESCRIPTION="Multipurpose automation tool for content like torrents, nzbs, podcasts, comics"
HOMEPAGE="http://flexget.com/"

LICENSE="MIT"
SLOT="0"
IUSE="test transmission"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/feedparser-5.1.3[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.7.5[${PYTHON_USEDEP}]
	<dev-python/sqlalchemy-1.999[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/babelfish-0.5.5[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-4.1:4[${PYTHON_USEDEP}]
	<dev-python/beautifulsoup-4.4:4[${PYTHON_USEDEP}]
	!~dev-python/beautifulsoup-4.2.0
	>=dev-python/html5lib-0.11[${PYTHON_USEDEP}]
	dev-python/PyRSS2Gen[${PYTHON_USEDEP}]
	dev-python/pynzb[${PYTHON_USEDEP}]
	dev-python/progressbar[${PYTHON_USEDEP}]
	>=dev-python/rebulk-0.6.4[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/rpyc[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/requests-1.0[${PYTHON_USEDEP}]
	<dev-python/requests-2.99[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	!~dev-python/python-dateutil-2.2
	>=dev-python/jsonschema-2.0[${PYTHON_USEDEP}]
	dev-python/python-tvrage[${PYTHON_USEDEP}]
	dev-python/tmdb3[${PYTHON_USEDEP}]
	dev-python/path-py[${PYTHON_USEDEP}]
	>=dev-python/guessit-2.0[${PYTHON_USEDEP}]
	dev-python/APScheduler[${PYTHON_USEDEP}]
	>=dev-python/pytvmaze-1.4.4[${PYTHON_USEDEP}]
	>=dev-python/pyScss-1.3.4[${PYTHON_USEDEP}]
	>=dev-python/flask-login-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/flask-compress-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/cssmin-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/flask-assets-0.11[${PYTHON_USEDEP}]
	>=dev-python/cherrypy-3.7.0[${PYTHON_USEDEP}]
	=dev-python/flask-restplus-0.8.6[${PYTHON_USEDEP}]
	>=dev-python/ordereddict-1.1[${PYTHON_USEDEP}]
	>=dev-python/flask-restful-0.3.3[${PYTHON_USEDEP}]
	virtual/python-pathlib[${PYTHON_USEDEP}]
	>=dev-python/webassets-0.11[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	transmission? ( dev-python/transmissionrpc[${PYTHON_USEDEP}] )
"
DEPEND+=" test? ( dev-python/nose[${PYTHON_USEDEP}] )"

if [[ ${PV} == 9999 ]]; then
	DEPEND+=" dev-python/paver[${PYTHON_USEDEP}]"
else
	S="${WORKDIR}/${MY_P}"
fi

python_prepare_all() {
	# Prevent setup from grabbing nose from pypi
	sed -e /setup_requires/d -i pavement.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	cp -lr tests setup.cfg "${BUILD_DIR}" || die
	run_in_build_dir nosetests -v --attr=!online > "${T}/tests-${EPYTHON}.log" \
		|| die "Tests fail with ${EPYTHON}"
}
