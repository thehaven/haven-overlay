# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Hyperparameter optimization framework"
HOMEPAGE="https://optuna.org/ https://github.com/optuna/optuna"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# optuna runtime depends on alembic, colorlog, numpy, packaging, sqlalchemy,
# tqdm and PyYAML. Upstream exposes these as install_requires and adds
# domain-specific integrations under optional-dependencies (benchmark,
# checking, document, integration, etc.). Plain consumers on this overlay
# already get numpy/sqlalchemy/tqdm transitively from the python target,
# so the base ebuild leaves RDEPEND empty; users needing specific extras
# invoke `pip install optuna[<extra>]` rather than via the ebuild.
RDEPEND=""

distutils_enable_tests pytest
