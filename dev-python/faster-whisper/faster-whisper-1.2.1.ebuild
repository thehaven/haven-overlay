# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="Faster Whisper transcription with CTranslate2"
HOMEPAGE="https://github.com/SYSTRAN/faster-whisper"
SRC_URI="https://github.com/SYSTRAN/faster-whisper/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/ctranslate2-4.0[${PYTHON_USEDEP}]
	>=dev-python/huggingface-hub-0.20[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.23[${PYTHON_USEDEP}]
	>=dev-python/tokenizers-0.19[${PYTHON_USEDEP}]
	>=dev-python/onnxruntime-1.17[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	media-video/ffmpeg
"

# No third-party pytest plugins required for this package.
EPYTEST_PLUGINS=()
distutils_enable_tests pytest
