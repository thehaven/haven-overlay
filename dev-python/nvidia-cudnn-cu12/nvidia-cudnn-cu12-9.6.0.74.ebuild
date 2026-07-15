# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# nvidia-cudnn-cu12 — wheel-only install pattern
# ------------------------------------------------------------------
# Upstream ships only a manylinux x86_64 wheel (no sdist). The wheel
# is python-version-agnostic (py3-none-any) and contains the cuDNN
# shared library (~480MB) plus headers. We treat it as a binary data
# package: unzip the wheel, copy the nvidia/ tree into python's
# sitedir per Python target.
#
# bindist: not redistributable through Gentoo's mirror network.
# strip:   prebuilt .so files are already stripped; do not re-strip.
# mirror:  do not let mirrors cache our copy of the redistributable.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="NVIDIA CUDA cuDNN runtime libraries (Python wheel)"
HOMEPAGE="https://pypi.org/project/nvidia-cudnn-cu12/"
SRC_URI="https://files.pythonhosted.org/packages/67/4c/0f18ddce75f2c17cf028d16e067c07f11c421c981b8c2a45c99bc6169af6/nvidia_cudnn_cu12-${PV}-py3-none-manylinux_2_27_x86_64.whl -> ${P}.x86_64.whl.zip"

S="${WORKDIR}"

LICENSE="NVIDIA-cuDNN"
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
	doins -r "${WORKDIR}/nvidia_cudnn_cu12-${PV}.dist-info"
}

src_install() {
	distutils-r1_src_install
}

pkg_postinst() {
	elog "nvidia-cudnn-cu12 installs the cuDNN shared libraries into"
	elog "python's site-packages under nvidia/cudnn/lib/."
	elog ""
	elog "Consumers (e.g. dev-python/onnxruntime-gpu) load these"
	elog "libraries via dlopen; ensure LD_LIBRARY_PATH includes the"
	elog "nvidia/cudnn/lib/ directory for the active Python interpreter,"
	elog "or add it to /etc/ld.so.conf.d/ and run ldconfig."
}
