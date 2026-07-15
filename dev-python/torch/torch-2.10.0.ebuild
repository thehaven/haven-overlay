# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="Tensors and dynamic neural networks in Python with strong GPU acceleration"
HOMEPAGE="https://pytorch.org https://pypi.org/project/torch/"

# PyPI hosts the official manylinux x86_64 CPU wheels (cp310..cp314). PyTorch
# does not publish an sdist for stable releases; the GitHub tag is the only
# source tree and is not practical to build under Portage (10k+ files,
# requires a pinned CUDA/cuDNN/NCCL toolchain for GPU builds).
#
# USE=cuda (off by default): pulls CPU wheels from PyPI.
# USE=cuda (on): pulls CUDA 12.6 wheels from the operator's internal
# artifactory mirror at https://artifactory.delivery.haven.pw/gentoo-distfiles/.
# PyPI does NOT host torch CUDA wheels, and download.pytorch.org (the
# canonical host) is geo-fenced from most build hosts (HTTP 403). To enable
# USE=cuda, the operator MUST pre-stage the upstream CUDA wheels into the
# artifactory mirror before emerging. The wheel filenames follow the
# PyTorch CUDA distribution convention, e.g.
#   torch-${PV}+cu126-cp312-cp312-linux_x86_64.whl
# upstream-hostable at
#   https://download.pytorch.org/whl/cu126/torch-${PV}+cu126-cp312-cp312-linux_x86_64.whl
#
# cp315 reuses the cp314 wheel: ABI-compatible forward, and PyTorch 2.10.0
# does not publish a cp315 build (first cp315 wheel is torch 2.13.0).
SRC_URI="
	!cuda? (
		python_targets_python3_12? (
			https://files.pythonhosted.org/packages/23/8e/3c74db5e53bff7ed9e34c8123e6a8bfef718b2450c35eefab85bb4a7e270/torch-${PV}-cp312-cp312-manylinux_2_28_x86_64.whl
			-> ${P}-cp312.whl.zip
		)
		python_targets_python3_13? (
			https://files.pythonhosted.org/packages/98/fb/5160261aeb5e1ee12ee95fe599d0541f7c976c3701d607d8fc29e623229f/torch-${PV}-cp313-cp313-manylinux_2_28_x86_64.whl
			-> ${P}-cp313.whl.zip
		)
		python_targets_python3_14? (
			https://files.pythonhosted.org/packages/5e/cd/4b95ef7f293b927c283db0b136c42be91c8ec6845c44de0238c8c23bdc80/torch-${PV}-cp314-cp314-manylinux_2_28_x86_64.whl
			-> ${P}-cp314.whl.zip
		)
		python_targets_python3_15? (
			https://files.pythonhosted.org/packages/5e/cd/4b95ef7f293b927c283db0b136c42be91c8ec6845c44de0238c8c23bdc80/torch-${PV}-cp314-cp314-manylinux_2_28_x86_64.whl
			-> ${P}-cp315.whl.zip
		)
	)
	cuda? (
		python_targets_python3_12? (
			https://artifactory.delivery.haven.pw/gentoo-distfiles/torch-${PV}+cu126-cp312-cp312-linux_x86_64.whl
			-> ${P}+cu126-cp312.whl.zip
		)
		python_targets_python3_13? (
			https://artifactory.delivery.haven.pw/gentoo-distfiles/torch-${PV}+cu126-cp313-cp313-linux_x86_64.whl
			-> ${P}+cu126-cp313.whl.zip
		)
		python_targets_python3_14? (
			https://artifactory.delivery.haven.pw/gentoo-distfiles/torch-${PV}+cu126-cp314-cp314-linux_x86_64.whl
			-> ${P}+cu126-cp314.whl.zip
		)
		python_targets_python3_15? (
			# cp315 reuses the cp314 CUDA wheel: ABI-compatible forward, and
			# PyTorch 2.10.0 does not publish a cp315 CUDA build.
			https://artifactory.delivery.haven.pw/gentoo-distfiles/torch-${PV}+cu126-cp314-cp314-linux_x86_64.whl
			-> ${P}+cu126-cp315.whl.zip
		)
	)
"

S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda"
# bindist: the manylinux x86_64 wheel is a redistributable binary, but
# PyTorch's licensing/CLA posture and the ~915 MB per-(cp, arch) footprint
# make mirroring into ::gentoo impractical. Distribution via overlay-local
# distfiles only.
RESTRICT="bindist"

BDEPEND="app-arch/unzip"

# C++ extension with PGO; no local compilation occurs.
QA_FLAGS_IGNORED=".*"

# Runtime dependencies (filelock, typing-extensions, sympy, networkx, jinja2,
# fsspec, setuptools) are bundled inside the torch wheel as of 2.10.0. They
# are NOT added to RDEPEND here on purpose - pulling them from the system
# risks version mismatches with the wheel's vendored copies. Add them to
# RDEPEND only if a downstream consumer (e.g. openai-whisper) explicitly
# imports a module torch's bundled copy does not expose.

RDEPEND="
	cuda? (
		>=dev-python/nvidia-cublas-cu12-12.6
		>=dev-python/nvidia-cudnn-cu12-9.6
		>=x11-drivers/nvidia-drivers-555
	)
"

src_unpack() {
	if use cuda; then
		if use python_targets_python3_12; then
			mkdir -p "${WORKDIR}/python3.12" || die
			cd "${WORKDIR}/python3.12" || die
			unpack "${P}+cu126-cp312.whl.zip"
		fi
		if use python_targets_python3_13; then
			mkdir -p "${WORKDIR}/python3.13" || die
			cd "${WORKDIR}/python3.13" || die
			unpack "${P}+cu126-cp313.whl.zip"
		fi
		if use python_targets_python3_14; then
			mkdir -p "${WORKDIR}/python3.14" || die
			cd "${WORKDIR}/python3.14" || die
			unpack "${P}+cu126-cp314.whl.zip"
		fi
		if use python_targets_python3_15; then
			mkdir -p "${WORKDIR}/python3.15" || die
			cd "${WORKDIR}/python3.15" || die
			unpack "${P}+cu126-cp315.whl.zip"
		fi
	else
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
	doins -r torch
	doins -r "${P}.dist-info"
}

src_install() {
	distutils-r1_src_install
}
