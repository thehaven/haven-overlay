# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
# Expanded from python3_12 to python3_{12..15} after pkgcheck reported
# `failed REQUIRED_USE: python_targets_python3_12` on the host's default/linux/amd64
# profile — the profile enables python_targets_python3_{12,13,14} and pkgcheck's
# REQUIRED_USE evaluation expects at least one PYTHON_COMPAT entry to match.
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="OpenAI-API-compatible server for STT/TTS powered by faster-whisper"
HOMEPAGE="https://speaches.ai/"
HOMEPAGE+=" https://github.com/speaches-ai/speaches"
SRC_URI="https://github.com/speaches-ai/speaches/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda diarization"

# Upstream pyproject.toml build-backend is hatchling; >=1.20 required.
BDEPEND=">=dev-python/hatchling-1.20"

# TODO: package dev-python/nvidia-cublas-cu12 (NVIDIA CUDA wheel) when USE=cuda
# TODO: package dev-python/nvidia-cudnn-cu12 (NVIDIA CUDA wheel) when USE=cuda
# TODO: package dev-python/onnxruntime-gpu when USE=cuda
RDEPEND="
	acct-user/speaches
	acct-group/speaches
	>=dev-python/faster-whisper-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/fastapi-0.121.1[${PYTHON_USEDEP}]
	>=dev-python/uvicorn-0.35.0[${PYTHON_USEDEP}]
	>=dev-python/ctranslate2-4.5[${PYTHON_USEDEP}]
	>=dev-python/huggingface-hub-0.33[${PYTHON_USEDEP}]
	>=dev-python/numpy-2.3[${PYTHON_USEDEP}]
	>=dev-python/soundfile-0.13[${PYTHON_USEDEP}]
	diarization? ( >=dev-python/pyannote-audio-4.0[${PYTHON_USEDEP}] )
	>=dev-python/pydantic-2.11[${PYTHON_USEDEP}]
	>=dev-python/pydantic-settings-2.0[${PYTHON_USEDEP}]
	>=dev-python/python-multipart-0.0.9[${PYTHON_USEDEP}]
	media-video/ffmpeg
	cuda? (
		dev-python/nvidia-cublas-cu12[${PYTHON_USEDEP}]
		dev-python/nvidia-cudnn-cu12[${PYTHON_USEDEP}]
		dev-python/onnxruntime-gpu[${PYTHON_USEDEP}]
	)
"

src_install() {
	distutils-r1_src_install

	newinitd "${FILESDIR}"/speaches.initd speaches
	newconfd "${FILESDIR}"/speaches.confd speaches

	keepdir /var/log/speaches /var/lib/speaches
	fowners -R speaches:speaches /var/log/speaches /var/lib/speaches
}
