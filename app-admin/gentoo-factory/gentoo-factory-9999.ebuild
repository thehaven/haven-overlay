# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..14} )

inherit distutils-r1

DESCRIPTION="A declarative Gentoo build orchestrator"
HOMEPAGE="https://github.com/haven/gentoo-factory"
SRC_URI=""
EGIT_REPO_URI="file:///home/haven/projects/gentoo-factory"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
else
	SRC_URI="https://github.com/haven/gentoo-factory/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/docker[${PYTHON_USEDEP}]
"
BDEPEND="
	doc? ( sys-apps/texinfo )
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-bdd[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_compile_all() {
	if use doc; then
		makeinfo docs/gentoo-factory.texi || die
	fi
}

python_install_all() {
	distutils-r1_python_install_all
	if use doc; then
		doman docs/gentoo-factory.1
		doinfo gentoo-factory.info
	fi
	
	insinto /usr/share/doc/${PF}/examples
	doins gentoo-factory.yaml
	
	insinto /etc/gentoo-factory
	newins gentoo-factory.yaml gentoo-factory.yaml.example
}
