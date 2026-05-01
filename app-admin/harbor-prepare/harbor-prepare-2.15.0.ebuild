# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit python-single-r1

DESCRIPTION="Prepare tool for Project Harbor configuration"
HOMEPAGE="https://github.com/goharbor/harbor"
SRC_URI="https://github.com/goharbor/harbor/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+python_single_target_python3_12 python_single_target_python3_11"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pipenv[${PYTHON_SINGLE_USEDEP}]
		dev-python/pyyaml[${PYTHON_SINGLE_USEDEP}]
		dev-python/jinja2[${PYTHON_SINGLE_USEDEP}]
	')"

S="${WORKDIR}/harbor-${PV}/make/photon/prepare"

src_install() {
	python_doscript main.py
	insinto /usr/share/harbor/prepare
	doins -r .
}
