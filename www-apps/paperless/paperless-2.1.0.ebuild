# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1 eutils user systemd

DESCRIPTION="Scan, index, and archive all of your paper documents"
HOMEPAGE="https://github.com/danielquinn/paperless"
SRC_URI="https://github.com/danielquinn/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nginx apache"

DEPEND=">=dev-python/apipkg-1.4[${PYTHON_USEDEP}]
        >=dev-python/attrs-18.1.0[${PYTHON_USEDEP}]
	    >=dev-python/certifi-2018.4.16[${PYTHON_USEDEP}]
		>=dev-python/chardet-3.0.4[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.5.1[${PYTHON_USEDEP}]
		>=dev-python/coveralls-1.3.0[${PYTHON_USEDEP}]
		>=dev-ptyhon/dateparser-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/django-crispy-forms-1.7.2[${PYTHON_USEDEP}]
		>=dev-python/django-extensions-2.0.7[${PYTHON_USEDEP}]
		>=dev-python/django-filter-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/django-flat-responsive-2.0[${PYTHON_USEDEP}]
		>=dev-python/django-1.11.13[${PYTHON_USEDEP}]
		>=dev-python/djangorestframework-3.8.2[${PYTHON_USEDEP}]
		>=dev-python/docopt-0.6.2[${PYTHON_USEDEP}]
		>=dev-python/execnet-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/factory-boy-2.11.1[${PYTHON_USEDEP}]
		>=dev-python/faker-0.8.15[${PYTHON_USEDEP}]
		>=dev-python/filemagic-1.6[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
