# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="Fast inference engine for Transformer models (C++ runtime)"
HOMEPAGE="https://github.com/OpenNMT/CTranslate2"
SRC_URI="https://github.com/OpenNMT/CTranslate2/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"

# C++ extension shipped as prebuilt wheels per-architecture; QA flags
# intentionally ignored as no source is compiled locally.
QA_FLAGS_IGNORED=".*"
