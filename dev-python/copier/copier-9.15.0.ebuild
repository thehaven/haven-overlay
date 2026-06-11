# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="A library for rendering project templates."
HOMEPAGE=""


LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/colorama dev-python/dunamai dev-python/funcy dev-python/jinja2-ansible-filters dev-python/jinja2 dev-python/packaging dev-python/pathspec dev-python/platformdirs dev-python/plumbum dev-python/pydantic dev-python/pygments dev-python/pyyaml dev-python/questionary
"
