# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# torchcodec — wheel-install notes
# ------------------------------------------------------------------
# PyPI hosts the official manylinux x86_64 wheels (cp310..cp314). No
# sdist is published. The wheel bundles a small libtorchcodec shared
# object; we install it as a binary distribution rather than rebuilding
# from source (which would require ffmpeg headers).
#
# cp315 reuses the cp314 wheel: ABI-compatible forward, and torchcodec
# 0.15.0 does not publish a cp315 build.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="PyTorch native video decoder"
HOMEPAGE="https://github.com/pytorch/torchcodec"

SRC_URI="
	python_targets_python3_12? (
		https://files.pythonhosted.org/packages/d0/05/b7ba7ae04db4afeb1fd32d30ec6290d511c374adc464afe191c8fc8d4e22/torchcodec-${PV}-cp312-cp312-manylinux_2_28_x86_64.whl
		-> ${P}-cp312.whl.zip
	)
	python_targets_python3_13? (
		https://files.pythonhosted.org/packages/70/ff/f0e5795100bdf11f6e73a2fcc5197e9010e45030c1ee7f6b3ee32cffefe4/torchcodec-${PV}-cp313-cp313-manylinux_2_28_x86_64.whl
		-> ${P}-cp313.whl.zip
	)
	python_targets_python3_14? (
		https://files.pythonhosted.org/packages/28/57/4bab825dbb8aff755c87ff040fd91e6dbc1bb7c51a9bd5b2fdd61fda0437/torchcodec-${PV}-cp314-cp314-manylinux_2_28_x86_64.whl
		-> ${P}-cp314.whl.zip
	)
	python_targets_python3_15? (
		https://files.pythonhosted.org/packages/28/57/4bab825dbb8aff755c87ff040fd91e6dbc1bb7c51a9bd5b2fdd61fda0437/torchcodec-${PV}-cp314-cp314-manylinux_2_28_x86_64.whl
		-> ${P}-cp315.whl.zip
	)
"

S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
# bindist: the manylinux x86_64 wheel is a redistributable binary. Keeping
# this overlay-local because libtorchcodec's footprint is heavy and the
# upstream release cadence is fast.
RESTRICT="bindist"

BDEPEND="app-arch/unzip"

# C++ extension with native code; no local compilation occurs.
QA_FLAGS_IGNORED=".*"

RDEPEND="
	>=dev-python/torch-2.10.0[${PYTHON_USEDEP}]
"

src_unpack() {
	if use python_targets_python3_12; then
		mkdir -p "${WORKDIR}/python3.12" || die
		cd "${WORKDIR}/python3.12" || die
		unpack "${P}-cp312.whl.zip"
	fi
	if use python_targets_python3_13; then
		mkdir -p "${WORKDIR}/python3.13" || die
		cd "${WORKDIR}/python3.13" || die
		unpack "${P}-cp313.whl.zip"
	fi
	if use python_targets_python3_14; then
		mkdir -p "${WORKDIR}/python3.14" || die
		cd "${WORKDIR}/python3.14" || die
		unpack "${P}-cp314.whl.zip"
	fi
	if use python_targets_python3_15; then
		mkdir -p "${WORKDIR}/python3.15" || die
		cd "${WORKDIR}/python3.15" || die
		unpack "${P}-cp315.whl.zip"
	fi
}

src_compile() {
	:
}

python_install() {
	local sitedir
	sitedir=$(python_get_sitedir)
	insinto "${sitedir}"
	cd "${WORKDIR}/${EPYTHON}" || die
	doins -r torchcodec
	if [ -d "${P}.dist-info" ]; then
		doins -r "${P}.dist-info"
	fi
}

src_install() {
	distutils-r1_src_install
}
