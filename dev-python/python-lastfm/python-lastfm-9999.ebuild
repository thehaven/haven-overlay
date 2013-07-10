# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit distutils eutils subversion

PYTHON_DEPEND="2:2.5:2.7"

DESCRIPTION="Python interface to the last.fm web services API located at http://ws.audioscrobbler.com/2.0/"
HOMEPAGE="http://code.google.com/p/python-lastfm/"
ESVN_REPO_URI="http://python-lastfm.googlecode.com/svn/trunk/"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="dev-lang/python:2.7
		dev-python/setuptools
		!media-sound/lastfmsubmitd"
RDEPEND="${DEPEND}"
