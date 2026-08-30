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
# 0.16.0 does not publish a cp315 build.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="PyTorch native video decoder"
HOMEPAGE="https://github.com/pytorch/torchcodec"

PY312_URL="https://files.pythonhosted.org/packages/ca/5b/2a15225d77fc2ef857bd290a98f1de99f0db03e104f93ce3af7bea704f4a/torchcodec-0.16.0-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
PY313_URL="https://files.pythonhosted.org/packages/41/1c/9b12cfd462ff2a7cbad52907de9dd1963bca7aa4bf6a4e2d618195af7275/torchcodec-0.16.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
PY314_URL="https://files.pythonhosted.org/packages/1c/58/07df4dc91580bc878eaf6f0b9b43c0823f67fb3a926e816c6869494b0710/torchcodec-0.16.0-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
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
