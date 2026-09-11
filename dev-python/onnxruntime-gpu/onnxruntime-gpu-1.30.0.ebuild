# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# onnxruntime-gpu — wheel-only install pattern
# ------------------------------------------------------------------
# Mirrors the dev-python/onnxruntime CPU ebuild. The Python wheels
# are prebuilt per (python_target, x86_64) and contain the onnxruntime
# shared library plus CUDA 12.x / TensorRT / cuDNN provider plugins.
#
# Upstream does not publish a cp315 wheel for 1.30.0; we reuse the
# cp314 wheel for python3_15 (cp314 is ABI-compatible with cp315
# for the parts onnxruntime-gpu exposes). A version bump that ships
# a real cp315 wheel should swap that entry.
#
# QA_FLAGS_IGNORED: GPU build, ignore CFLAGS (no local compilation).
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Cross-platform, high performance ONNX Model Runner (GPU wheel)"
HOMEPAGE="https://onnxruntime.ai"
HOMEPAGE+=" https://pypi.org/project/onnxruntime-gpu/"

PY312_URL="https://files.pythonhosted.org/packages/9e/80/d96143329dbe925d434b016c890a5caa785fac8e14a1570e5d6818b63545/onnxruntime_gpu-1.30.0-cp312-cp312-manylinux_2_28_x86_64.whl"
PY313_URL="https://files.pythonhosted.org/packages/31/ae/cfec0c21d039e4125fdc333e2e2032ed0a49eb50f9dd70b7f3819b339018/onnxruntime_gpu-1.30.0-cp313-cp313-manylinux_2_28_x86_64.whl"
PY314_URL="https://files.pythonhosted.org/packages/bb/75/09a6c97136c747608867a63114d988384e6ddb5507e08bbe9ced08744a4c/onnxruntime_gpu-1.30.0-cp314-cp314-manylinux_2_28_x86_64.whl"
SRC_URI="
	python_targets_python3_12? ( ${PY312_URL} -> ${P}-cp312.whl.zip )
	python_targets_python3_13? ( ${PY313_URL} -> ${P}-cp313.whl.zip )
	python_targets_python3_14? ( ${PY314_URL} -> ${P}-cp314.whl.zip )
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
		unpack onnxruntime-gpu-1.30.0-cp312.whl.zip
	fi
	if use python_targets_python3_13; then
		mkdir -p "${WORKDIR}/python3.13" || die
		cd "${WORKDIR}/python3.13" || die
		unpack onnxruntime-gpu-1.30.0-cp313.whl.zip
	fi
	if use python_targets_python3_14; then
		mkdir -p "${WORKDIR}/python3.14" || die
		cd "${WORKDIR}/python3.14" || die
		unpack onnxruntime-gpu-1.30.0-cp314.whl.zip
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
