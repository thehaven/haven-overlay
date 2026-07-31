# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="CSS minifier, written in python"
HOMEPAGE="
	https://github.com/sprymix/csscompressor
	https://pypi.org/project/csscompressor/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="test"
RESTRICT="!test? ( test )"

python_test() {
	python - <<-EOF_TEST || die "csscompressor functional test failed"
from csscompressor import compress

out = compress("body { color: red; }\n")
assert out == "body{color:red}", out
out = compress("a { color: #ffffff; }\n")
assert out == "a{color:#fff}", out
EOF_TEST
}
