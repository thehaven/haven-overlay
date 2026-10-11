# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit python-r1

DESCRIPTION="LanceDB: A serverless, low-latency vector database for AI applications"
HOMEPAGE="https://lancedb.github.io/lancedb/ https://github.com/lancedb/lancedb"

# lancedb does NOT publish an sdist on PyPI. Upstream only ships binary
# manylinux/macosx/windows wheels (the Rust Lance core is built via NAPI
# and bundled into the wheel). This ebuild installs the prebuilt amd64
# wheel directly. If upstream ever ships an sdist, switch to distutils-r1
# + pypi.
SRC_URI="
	amd64? ( https://files.pythonhosted.org/packages/66/21/153a42294279c5b66d763f357808dde0899b71c5c8e41ad5ecbeeb8728df/lancedb-0.29.2-cp39-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl -> ${P}-amd64.whl )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Hard runtime deps from lancedb 0.29.2 PyPI metadata (non-extra).
# `cp39-abi3` wheel is compatible with all targets in PYTHON_COMPAT.
RDEPEND="${PYTHON_DEPS}
	>=dev-python/deprecation-2.1.0
	>=dev-python/numpy-1.22.5
	>=dev-python/packaging-20.0
	>=dev-python/pyarrow-16
	>=dev-python/pydantic-1.10
	>=dev-python/tqdm-4.27.0
	>=dev-python/lance-namespace-0.3.2
"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

# No build step: the wheel is the artifact. Unpack is a no-op; the file
# is already in ${DISTDIR} after the SRC_URI fetch.
src_unpack() {
	:
}

src_install() {
	python_foreach_impl my_python_install
}

my_python_install() {
	local arch
	if use amd64; then
		arch="amd64"
	else
		die "Unsupported architecture"
	fi

	mkdir -p "${D}/$(python_get_sitedir)" || die
	unzip -o "${DISTDIR}/${PN}-${PV}-${arch}.whl" \
		-d "${D}/$(python_get_sitedir)" || die
}
