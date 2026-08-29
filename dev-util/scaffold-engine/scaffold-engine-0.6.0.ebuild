# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Project scaffold and governance engine"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/ai-ml/scaffold-engine"
SRC_URI="https://gitlab-ee.thehavennet.org.uk/ai-ml/scaffold-engine/-/archive/v${PV}/scaffold-engine-v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dag +semantic-release"

RDEPEND="
	dev-python/copier[${PYTHON_USEDEP}]
	dev-python/dvc[dag?,${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	semantic-release? ( dev-python/python-semantic-release[${PYTHON_USEDEP}] )
"
BDEPEND="dev-python/uv-build[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

S="${WORKDIR}/${PN}-v${PV}"

src_test() {
	export PATH="${BUILD_DIR}/install/usr/bin:${PATH}"
	distutils-r1_src_test
}
