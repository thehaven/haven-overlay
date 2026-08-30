# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# nvidia-nvtx-cu12 — wheel-only install pattern
# ------------------------------------------------------------------
# Upstream ships only a manylinux x86_64 wheel (no sdist). The wheel
# is python-version-agnostic (py3-none-any) and contains NVIDIA NVTX
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

DESCRIPTION="NVIDIA CUDA NVTX runtime libraries (Python wheel)"
HOMEPAGE="https://pypi.org/project/nvidia-nvtx-cu12/"
WHEEL_URL="https://files.pythonhosted.org/packages/86/ed/bb230dce7741f2778ba2ae3e8778fdb8bc58eee9fd95f07bf7b2d18e8081/nvidia_nvtx_cu12-12.9.79-py3-none-manylinux1_x86_64.manylinux_2_5_x86_64.whl"
SRC_URI="${WHEEL_URL} -> ${P}.x86_64.whl.zip"

S="${WORKDIR}"

LICENSE="BSD"
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
	doins -r "${WORKDIR}/nvidia/nvtx"
	if [[ ! -e "${sitedir}/nvidia/__init__.py" ]]; then
		insinto "${sitedir}/nvidia"
		doins "${WORKDIR}/nvidia/__init__.py"
	fi
	insinto "${sitedir}"
	doins -r "${WORKDIR}/nvidia_nvtx_cu12-12.9.79.dist-info"
}

src_install() {
	distutils-r1_src_install
}

pkg_postinst() {
	elog "nvidia-nvtx-cu12 installs the NVIDIA NVTX shared libraries into"
	elog "python's site-packages under nvidia/nvtx/lib/."
	elog ""
	elog "Consumers (e.g. dev-python/torch with USE=cuda) load these"
	elog "libraries via dlopen; ensure LD_LIBRARY_PATH includes the"
	elog "nvidia/nvtx/lib/ directory for the active Python interpreter, or"
	elog "add it to /etc/ld.so.conf.d/ and run ldconfig."
}
