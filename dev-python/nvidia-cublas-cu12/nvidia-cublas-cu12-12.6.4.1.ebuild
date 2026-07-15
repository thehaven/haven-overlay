# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# nvidia-cublas-cu12 — wheel-only install pattern
# ------------------------------------------------------------------
# Upstream ships only a manylinux x86_64 wheel (no sdist). The wheel
# is python-version-agnostic (py3-none-any) and contains a single
# libcublas.so.12 + libcublasLt.so.12 + headers. We treat it as a
# binary data package: unzip the wheel, copy the nvidia/ tree into
# python's sitedir per Python target.
#
# bindist: not redistributable through Gentoo's mirror network.
# strip:   prebuilt .so files are already stripped; do not re-strip.
# mirror:  do not let mirrors cache our copy of the redistributable.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="NVIDIA CUDA cuBLAS runtime libraries (Python wheel)"
HOMEPAGE="https://pypi.org/project/nvidia-cublas-cu12/"
SRC_URI="https://files.pythonhosted.org/packages/af/eb/ff4b8c503fa1f1796679dce648854d58751982426e4e4b37d6fce49d259c/nvidia_cublas_cu12-${PV}-py3-none-manylinux2014_x86_64.manylinux_2_17_x86_64.whl -> ${P}.x86_64.whl.zip"

S="${WORKDIR}"

LICENSE="NVIDIA-CUDA"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror strip"

BDEPEND="app-arch/unzip"
QA_FLAGS_IGNORED=".*"
QA_PREBUILT=".*"

src_unpack() {
	default
}

src_compile() {
	:
}

python_install() {
	local sitedir=$(python_get_sitedir)
	insinto "${sitedir}"
	doins -r "${WORKDIR}/nvidia"
	doins -r "${WORKDIR}/nvidia_cublas_cu12-${PV}.dist-info"
}

src_install() {
	distutils-r1_src_install
}

pkg_postinst() {
	elog "nvidia-cublas-cu12 installs the cuBLAS shared libraries into"
	elog "python's site-packages under nvidia/cublas/lib/."
	elog ""
	elog "Consumers (e.g. dev-python/torch, dev-python/onnxruntime-gpu) load"
	elog "these libraries via dlopen; ensure LD_LIBRARY_PATH includes the"
	elog "nvidia/cublas/lib/ directory for the active Python interpreter, or"
	elog "add it to /etc/ld.so.conf.d/ and run ldconfig."
}
