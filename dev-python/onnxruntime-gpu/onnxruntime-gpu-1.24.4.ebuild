# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# onnxruntime-gpu — wheel-only install pattern
# ------------------------------------------------------------------
# Mirrors the dev-python/onnxruntime CPU ebuild. The Python wheels
# are prebuilt per (python_target, x86_64) and contain the onnxruntime
# shared library plus CUDA 12.x / TensorRT / cuDNN provider plugins.
#
# Upstream does not publish a cp315 wheel for 1.24.4; we reuse the
# cp314 wheel for python3_15 (cp314 is ABI-compatible with cp315
# for the parts onnxruntime-gpu exposes). A version bump that ships
# a real cp315 wheel should swap that entry.
#
# QA_FLAGS_IGNORED: GPU build, ignore CFLAGS (no local compilation).
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="Cross-platform, high performance ONNX Model Runner (GPU wheel)"
HOMEPAGE="https://onnxruntime.ai"
HOMEPAGE+=" https://pypi.org/project/onnxruntime-gpu/"

SRC_URI="
	python_targets_python3_12? ( https://files.pythonhosted.org/packages/d0/2c/5b3fd4748cf7ed291eae541a37e426efc20ea04cb6e6a05768304ab0aa41/onnxruntime_gpu-${PV}-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl -> ${P}-cp312.whl.zip )
	python_targets_python3_13? ( https://files.pythonhosted.org/packages/be/4e/56d11203d7a35e7d6a5ea735f5fecb8673537038c07323e8d3090a896547/onnxruntime_gpu-${PV}-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl -> ${P}-cp313.whl.zip )
	python_targets_python3_14? ( https://files.pythonhosted.org/packages/3e/5b/82b27f766b64f97c9a98b772dc07b608e900bd2faafdfa176b86d20be7f8/onnxruntime_gpu-${PV}-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl -> ${P}-cp314.whl.zip )
	python_targets_python3_15? ( https://files.pythonhosted.org/packages/3e/5b/82b27f766b64f97c9a98b772dc07b608e900bd2faafdfa176b86d20be7f8/onnxruntime_gpu-${PV}-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl -> ${P}-cp315.whl.zip )
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"
QA_FLAGS_IGNORED=".*"

src_unpack() {
	if use python_targets_python3_12; then
		mkdir -p "${WORKDIR}/python3.12" || die
		cd "${WORKDIR}/python3.12" || die
		unpack onnxruntime-gpu-1.24.4-cp312.whl.zip
	fi
	if use python_targets_python3_13; then
		mkdir -p "${WORKDIR}/python3.13" || die
		cd "${WORKDIR}/python3.13" || die
		unpack onnxruntime-gpu-1.24.4-cp313.whl.zip
	fi
	if use python_targets_python3_14; then
		mkdir -p "${WORKDIR}/python3.14" || die
		cd "${WORKDIR}/python3.14" || die
		unpack onnxruntime-gpu-1.24.4-cp314.whl.zip
	fi
	if use python_targets_python3_15; then
		mkdir -p "${WORKDIR}/python3.15" || die
		cd "${WORKDIR}/python3.15" || die
		unpack onnxruntime-gpu-1.24.4-cp315.whl.zip
	fi
}

src_compile() {
	:
}

python_install() {
	local sitedir=$(python_get_sitedir)
	insinto "${sitedir}"
	cd "${WORKDIR}/${EPYTHON}" || die
	doins -r onnxruntime
	doins -r onnxruntime_gpu-*.dist-info
}

src_install() {
	distutils-r1_src_install
}

pkg_postinst() {
	elog "onnxruntime-gpu installs prebuilt onnxruntime shared libraries"
	elog "with the CUDA / TensorRT / cuDNN execution providers."
	elog ""
	elog "To use GPU acceleration, the matching dev-python/nvidia-cublas-cu12"
	elog "and dev-python/nvidia-cudnn-cu12 wheels must be importable for the"
	elog "active Python interpreter, and the corresponding libcuda.so.1 must"
	elog "be reachable via LD_LIBRARY_PATH or /etc/ld.so.conf.d/."
}
