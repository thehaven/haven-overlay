# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# onnxruntime-gpu — wheel-only install pattern
# ------------------------------------------------------------------
# Mirrors the dev-python/onnxruntime CPU ebuild. The Python wheels
# are prebuilt per (python_target, x86_64) and contain the onnxruntime
# shared library plus CUDA 12.x / TensorRT / cuDNN provider plugins.
#
# Upstream does not publish a cp315 wheel for 1.31.1; we reuse the
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

PY312_URL="https://files.pythonhosted.org/packages/22/97/9531b4d9e566cf2a0f04b4b5c26a3bc0ef2e2e0b6bc943a02c0eead98cf7/onnxruntime_gpu-1.31.1-cp312-cp312-manylinux_2_28_x86_64.whl"
PY313_URL="https://files.pythonhosted.org/packages/c5/ee/f189d535ccd8967009329682c2e9f9cc2508936d8969b70f2b0ccd29d27b/onnxruntime_gpu-1.31.1-cp313-cp313-manylinux_2_28_x86_64.whl"
PY314_URL="https://files.pythonhosted.org/packages/fd/56/23015d5deaf361d85eacf5db7d9c2d60552c728f5c1884dbf279a3e42d19/onnxruntime_gpu-1.31.1-cp314-cp314-manylinux_2_28_x86_64.whl"
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
		unpack onnxruntime-gpu-1.31.1-cp312.whl.zip
	fi
	if use python_targets_python3_13; then
		mkdir -p "${WORKDIR}/python3.13" || die
		cd "${WORKDIR}/python3.13" || die
		unpack onnxruntime-gpu-1.31.1-cp313.whl.zip
	fi
	if use python_targets_python3_14; then
		mkdir -p "${WORKDIR}/python3.14" || die
		cd "${WORKDIR}/python3.14" || die
		unpack onnxruntime-gpu-1.31.1-cp314.whl.zip
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
