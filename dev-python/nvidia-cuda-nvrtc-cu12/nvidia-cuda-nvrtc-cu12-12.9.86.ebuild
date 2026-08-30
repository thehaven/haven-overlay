# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# nvidia-cuda-nvrtc-cu12 — wheel-only install pattern
# ------------------------------------------------------------------
# Upstream ships only a manylinux x86_64 wheel (no sdist). The wheel
# is python-version-agnostic (py3-none-any) and contains NVIDIA CUDA NVRTC
# shared libraries plus headers. We treat it as a binary data package:
# unzip the wheel, copy the nvidia/ tree into python's sitedir per
# Python target.
#
# bindist: not redistributable through Gentoo's mirror network.
# strip:   prebuilt .so files are already stripped; do not re-strip.
# mirror:  do not let mirrors cache our copy of the redistributable.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="NVIDIA CUDA NVRTC runtime libraries (Python wheel)"
HOMEPAGE="https://pypi.org/project/nvidia-cuda-nvrtc-cu12/"
WHEEL_URL="https://files.pythonhosted.org/packages/b8/85/e4af82cc9202023862090bfca4ea827d533329e925c758f0cde964cb54b7/nvidia_cuda_nvrtc_cu12-12.9.86-py3-none-manylinux2010_x86_64.manylinux_2_12_x86_64.whl"
SRC_URI="${WHEEL_URL} -> ${P}.x86_64.whl.zip"

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
	# Install only this package's component dir: every nvidia wheel ships a
	# shared 0-byte nvidia/__init__.py namespace marker, so installing the
	# whole nvidia/ tree from each package collides on that file.
	insinto "${sitedir}/nvidia"
	doins -r "${WORKDIR}/nvidia/cuda_nvrtc"
	if [[ ! -e "${sitedir}/nvidia/__init__.py" ]]; then
		insinto "${sitedir}/nvidia"
		doins "${WORKDIR}/nvidia/__init__.py"
	fi
	insinto "${sitedir}"
	doins -r "${WORKDIR}/nvidia_cuda_nvrtc_cu12-12.9.86.dist-info"
}

src_install() {
	distutils-r1_src_install
}

pkg_postinst() {
	elog "nvidia-cuda-nvrtc-cu12 installs the NVIDIA CUDA NVRTC shared libraries into"
	elog "python's site-packages under nvidia/cuda_nvrtc/lib/."
	elog ""
	elog "Consumers (e.g. dev-python/torch with USE=cuda) load these"
	elog "libraries via dlopen; ensure LD_LIBRARY_PATH includes the"
	elog "nvidia/cuda_nvrtc/lib/ directory for the active Python interpreter, or"
	elog "add it to /etc/ld.so.conf.d/ and run ldconfig."
}
