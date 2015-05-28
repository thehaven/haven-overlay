# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyacoustid/pyacoustid-1.0.0-r1.ebuild,v 1.1 2014/04/02 05:26:04 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1 git-2
EGIT_REPO_URI="https://github.com/i-kiwamu/python3-oauth2.git"

DESCRIPTION="A fully tested, abstract interface to creating OAuth clients and servers."
HOMEPAGE="https://github.com/i-kiwamu/python3-oauth2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~*"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="!dev-python/oauth2
		dev-python/parse"

python_prepare_all() {
	rm -r tests
	distutils-r1_python_prepare_all
}
