# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 git-r3

DESCRIPTION="Vault write-side tooling for Proofpoint Obsidian vault"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/ai-ml/better-brain"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/ai-ml/better-brain.git"

if [[ ${PV} != 9999 ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64 ~arm64"
else
	KEYWORDS=""
fi

LICENSE="Proprietary"
SLOT="0"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/markdownify[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
