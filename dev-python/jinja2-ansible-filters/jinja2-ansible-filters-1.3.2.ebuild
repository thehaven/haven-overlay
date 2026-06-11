# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="Jinja2 filters for Ansible"
HOMEPAGE="https://pypi.org/project/jinja2-ansible-filters/"
HOMEPAGE="https://pypi.org/project/jinja2-ansible-filters/"
SRC_URI="https://files.pythonhosted.org/packages/source/j/jinja2-ansible-filters/jinja2-ansible-filters-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/jinja2"
