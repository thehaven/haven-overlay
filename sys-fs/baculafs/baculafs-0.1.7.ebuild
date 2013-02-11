# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Ebuild generated by g-pypi 0.3

EAPI="4"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="BaculaFS is a tool, developed independently of Bacula, that
represents the Bacula catalog and backup storage media as a read-only filesystem
in userspace."
HOMEPAGE="http://code.google.com/p/baculafs/"
SRC_URI="http://pypi.python.org/packages/source/B/BaculaFS/BaculaFS-${PV}.tar.gz"
#http://pypi.python.org/packages/source/B/BaculaFS/BaculaFS-0.1.7.tar.gz

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="sys-fs/fuse
		dev-python/fuse-python
		app-backup/bacula"

S="${WORKDIR}/BaculaFS-${PV}"