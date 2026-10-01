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
# 0.17.0 does not publish a cp315 build.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="PyTorch native video decoder"
HOMEPAGE="https://github.com/pytorch/torchcodec"

PY312_URL="https://files.pythonhosted.org/packages/05/44/d00a4df9c8985c6ce9e6d1e3f861496cdcde8b5b4b7543358d49e03f7337/torchcodec-0.17.0-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
PY313_URL="https://files.pythonhosted.org/packages/68/2f/11ed8af589bcac10e6de4801728d21e44a71492578b6bb3d423841de2141/torchcodec-0.17.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
PY314_URL="https://files.pythonhosted.org/packages/f7/98/986613945043b8beefd482c32c68fe20d7b9c79f28a5bd4da78a4144184e/torchcodec-0.17.0-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
SRC_URI="
	python_targets_python3_12? (
		${PY312_URL}
		-> ${P}-cp312.whl.zip
	)
	python_targets_python3_13? (
		${PY313_URL}
		-> ${P}-cp313.whl.zip
	)
	python_targets_python3_14? (
		${PY314_URL}
		-> ${P}-cp314.whl.zip
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
