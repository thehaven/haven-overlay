# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="Various BM25 algorithms for document ranking"
HOMEPAGE="https://github.com/dorianbrown/rank_bm25"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	cat > version.py <<-PYEOF
	import re

	version_re = re.compile('^Version: (.+)$', re.M)

	def get_version():
	    with open("PKG-INFO") as f:
	        return version_re.search(f.read()).group(1)
	PYEOF
}
