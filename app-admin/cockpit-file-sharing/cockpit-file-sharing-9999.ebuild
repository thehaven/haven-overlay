# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit python-single-r1 git-r3

DESCRIPTION="A Cockpit plugin to easily manage samba and NFS file sharing."
HOMEPAGE="https://github.com/45Drives/cockpit-file-sharing"

EGIT_REPO_URI="https://github.com/45Drives/cockpit-file-sharing"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
BDEPEND=""
RDEPEND="${DEPEND}
	app-admin/cockpit
	net-fs/samba
	net-fs/nfs-utils
	${PYTHON_DEPS}
"
