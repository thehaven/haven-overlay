# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

PYTHON_COMPAT=( python3_{5..10} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="The command-line tool that gives easy access to all of the capabilities of B2 Cloud Storage"
HOMEPAGE="https://github.com/Backblaze/B2_Command_Line_Tool"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/arrow-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/b2sdk-1.12.0[${PYTHON_USEDEP}]
		=dev-python/rst2ansi-0.1.5[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

python_prepare_all() {
	rm -r test
	distutils-r1_python_prepare_all
}

python_install_all() {
	# mv /usr/bin/b2 to /usr/local/bin/b2 prevent collisions with boost:
	mkdir -p ${PORTAGE_BUILDDIR}/image/usr/local/bin/
	rm ${PORTAGE_BUILDDIR}/image/usr/bin/b2
	ln -s ${PORTAGE_BUILDDIR}/image/usr/lib/python-exec/python-exec2 ${PORTAGE_BUILDDIR}/image/usr/local/bin/b2
	distutils-r1_python_install_all
}
