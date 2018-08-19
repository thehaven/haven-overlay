# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils git-r3

DESCRIPTION="Python modules and utilities for Nagios plugins and configuration"
HOMEPAGE="https://github.com/pynag/pynag"
EGIT_REPO_URI="https://github.com/pynag/pynag.git"
REVISION=${PR/r/-}
EGIT_COMMIT=${P}${REVISION}

LICENSE=""
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
