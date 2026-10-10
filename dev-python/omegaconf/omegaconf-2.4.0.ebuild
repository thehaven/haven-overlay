# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 pypi

DESCRIPTION="A flexible configuration library"
HOMEPAGE="https://github.com/omry/omegaconf"


LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Upstream pins antlr4-python3-runtime==4.9.* — its generated grammar is
# ATN-v3 and newer runtimes (4.13+, ATN v4) refuse to deserialize it.
# The 4.9.3 ebuild lives in this overlay (::gentoo only ships 4.13.2).
RDEPEND="
	=dev-python/antlr4-python3-runtime-4.9.3*
	dev-python/pyyaml
"
