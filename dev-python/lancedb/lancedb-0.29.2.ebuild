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
# files.pythonhosted.org embeds a per-release content hash in its paths, so the
# wheel URL cannot be derived from ${PV}. The wheel tag is not stable either:
# 0.29.x ships cp39-abi3-manylinux_2_17_x86_64, 0.40.x ships
# cp310-abi3-manylinux_2_28_x86_64. metadata/bump-hooks/dev-python/lancedb
# rewrites the WHEEL_URL line below with the URL the PyPI JSON API reports for
# the version being bumped.
WHEEL_URL="https://files.pythonhosted.org/packages/66/21/153a42294279c5b66d763f357808dde0899b71c5c8e41ad5ecbeeb8728df/lancedb-0.29.2-cp39-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
SRC_URI="
	amd64? ( ${WHEEL_URL} -> ${P}-amd64.whl )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cpu_flags_x86_avx2"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	amd64? ( cpu_flags_x86_avx2 )
"

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

pkg_pretend() {
	if use amd64; then
		if [[ -f /proc/cpuinfo ]]; then
			if ! grep -q '\<avx2\>' /proc/cpuinfo; then
				eerror "${PN} upstream binary wheel is compiled for x86-64-v3 (requires AVX2)."
				eerror "Your CPU does not report 'avx2' support in /proc/cpuinfo."
				die "CPU lacks required AVX2 instruction support"
			fi
			if ! grep -q '\<bmi2\>' /proc/cpuinfo; then
				eerror "${PN} upstream binary wheel is compiled for x86-64-v3 (requires BMI2)."
				eerror "Your CPU does not report 'bmi2' support in /proc/cpuinfo."
				die "CPU lacks required BMI2 instruction support"
			fi
		fi
	fi
}

pkg_setup() {
	pkg_pretend
}

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
