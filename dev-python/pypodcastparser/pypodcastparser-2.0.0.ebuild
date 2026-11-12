# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 2016 release with PyPI-only distribution. No v2.0.0 tag exists upstream;
# pin SRC_URI to the release commit (mirrors "version 2.0.0" at 63a0a1c76c7a).
COMMIT_ID="63a0a1c76c7a"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="Simple podcast parser for Python"
HOMEPAGE="https://github.com/mr-rigden/pyPodcastParser"

SRC_URI="https://github.com/mr-rigden/pyPodcastParser/archive/${COMMIT_ID}.tar.gz -> ${P}.gh.tar.gz"

S="${WORKDIR}/pyPodcastParser-${COMMIT_ID}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
