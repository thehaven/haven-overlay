# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Tensors and dynamic neural networks in Python with strong GPU acceleration"
HOMEPAGE="https://pytorch.org https://pypi.org/project/torch/"

# PyPI hosts the official manylinux x86_64 CPU wheels (cp310..cp314). PyTorch
# does not publish an sdist for stable releases; the GitHub tag is the only
# source tree and is not practical to build under Portage (10k+ files,
# requires a pinned CUDA/cuDNN/NCCL toolchain for GPU builds).
#
# USE=cuda (off by default): pulls CPU wheels from PyPI.
# USE=cuda (on): pulls CUDA 12.6 wheels from download.pytorch.org/whl/cu126/
# (the canonical host). The '+' in the local version must be URL-encoded as
# %2B (a raw '+' returns 403). Wheel tags are manylinux_2_28_x86_64.
#
# cp315 reuses the cp314 wheel: ABI-compatible forward, and PyTorch 2.14.1
# does not publish a cp315 build (first cp315 wheel is torch 2.13.0).
#
# files.pythonhosted.org embeds a per-release content hash in its paths, so the
# three CPU wheel URLs below cannot be derived from ${PV} - every new version
# 404s the previous release's paths. metadata/bump-hooks/dev-python/torch
# rewrites the three TORCH_CP*_URL lines with the URLs the PyPI JSON API reports
# for the version being bumped. The CUDA URLs are unaffected:
# download.pytorch.org serves plain paths.
TORCH_CP312_URL="https://files.pythonhosted.org/packages/ba/fd/c470857d0dfc5d4c94430658b3eed60fd5292b0bf596a8aae7b9fd66d674/torch-2.14.1-cp312-cp312-manylinux_2_28_x86_64.whl"
TORCH_CP313_URL="https://files.pythonhosted.org/packages/7c/cc/bb579ac0c80e077c58204e43b37a254b74dea5873635100bea25789a55d4/torch-2.14.1-cp313-cp313-manylinux_2_28_x86_64.whl"
TORCH_CP314_URL="https://files.pythonhosted.org/packages/fd/df/23c69e9b9fd19fe6563422f1bc59f89601bda47234a89a1cf432cfde3aee/torch-2.14.1-cp314-cp314-manylinux_2_28_x86_64.whl"
SRC_URI="
	!cuda? (
		python_targets_python3_12? (
			${TORCH_CP312_URL}
			-> ${P}-cp312.whl.zip
		)
		python_targets_python3_13? (
			${TORCH_CP313_URL}
			-> ${P}-cp313.whl.zip
		)
		python_targets_python3_14? (
			${TORCH_CP314_URL}
			-> ${P}-cp314.whl.zip
		)
	)
	cuda? (
		python_targets_python3_12? (
			https://download.pytorch.org/whl/cu126/torch-${PV}%2Bcu126-cp312-cp312-manylinux_2_28_x86_64.whl
			-> ${P}+cu126-cp312.whl.zip
		)
		python_targets_python3_13? (
			https://download.pytorch.org/whl/cu126/torch-${PV}%2Bcu126-cp313-cp313-manylinux_2_28_x86_64.whl
			-> ${P}+cu126-cp313.whl.zip
		)
		python_targets_python3_14? (
			https://download.pytorch.org/whl/cu126/torch-${PV}%2Bcu126-cp314-cp314-manylinux_2_28_x86_64.whl
			-> ${P}+cu126-cp314.whl.zip
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
		>=x11-drivers/nvidia-drivers-555
		=dev-python/nvidia-cublas-cu12-12.6.4.1
		=dev-python/nvidia-cudnn-cu12-9.10.2.21
		=dev-python/nvidia-cuda-nvrtc-cu12-12.6.77
		=dev-python/nvidia-cuda-runtime-cu12-12.6.77
		=dev-python/nvidia-cuda-cupti-cu12-12.6.80
		=dev-python/nvidia-cufft-cu12-11.3.0.4
		=dev-python/nvidia-curand-cu12-10.3.7.77
		=dev-python/nvidia-cusolver-cu12-11.7.1.2
		=dev-python/nvidia-cusparse-cu12-12.5.4.2
		=dev-python/nvidia-cusparselt-cu12-0.7.1
		=dev-python/nvidia-nccl-cu12-2.27.5
		=dev-python/nvidia-nvshmem-cu12-3.4.5
		=dev-python/nvidia-nvtx-cu12-12.6.77
		=dev-python/nvidia-nvjitlink-cu12-12.6.85
		=dev-python/nvidia-cufile-cu12-1.11.1.6
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
	fi
}

src_compile() {
	:
}

python_install() {
	local sitedir distinfo
	sitedir=$(python_get_sitedir)
	insinto "${sitedir}"
	cd "${WORKDIR}/${EPYTHON}" || die
	doins -r torch
	# The wheel also ships top-level torchgen/ and functorch/ packages
	# (torch imports both at runtime); install them alongside torch.
	doins -r torchgen
	doins -r functorch
	# The cu126 wheel's dist-info carries the local version
	# (torch-2.10.0+cu126.dist-info); the PyPI wheel does not.
	distinfo="torch-${PV}.dist-info"
	use cuda && distinfo="torch-${PV}+cu126.dist-info"
	doins -r "${distinfo}"
}

src_install() {
	distutils-r1_src_install
}
