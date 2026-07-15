# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# pyannote-audio 4.x — source-build notes
# ------------------------------------------------------------------
# Upstream build-system is hatchling with hatch-vcs dynamic version.
# The sdist ships a PKG-INFO with the version baked in, so hatch-vcs
# resolves the version from PKG-INFO when the archive is unpacked
# outside a git checkout. No network access is required at build time.
#
# Several runtime deps requested in the spec (pyannote-core 5.0,
# pyannote-database 5.1, pyannote-metrics 3.2) are too old for 4.0.x;
# upstream pyproject.toml pins pyannote-core>=6.0.1,
# pyannote-database>=6.1.1, pyannote-metrics>=4.0.0. This ebuild
# mirrors upstream's declared minimums and only emits entries for
# packages already available in ::gentoo or this overlay; the
# remaining deps are listed below as a comment block so the
# dependency graph stays self-consistent.
#
# TODOs (not yet packaged): upstream's transitive deps that are NOT
# yet in this overlay or ::gentoo. Each listed here is also flagged
# in its direct parent's ebuild so the build chain is self-documenting:
#   - dev-python/opentelemetry-semantic-conventions
#       (declared by opentelemetry-sdk)
#   - dev-python/opentelemetry-exporter-otlp-proto-grpc
#   - dev-python/opentelemetry-exporter-otlp-proto-http
#       (both declared by opentelemetry-exporter-otlp)
#   - dev-python/julius
#   - dev-python/torch-pitch-shift
#       (both declared by torch-audiomentations)
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="State-of-the-art speaker diarization toolkit"
HOMEPAGE="https://github.com/pyannote/pyannote-audio"
SRC_URI="https://files.pythonhosted.org/packages/41/ee/ce292efdb0d0637b8adc1fbb5834f9f1e5d5ca574f1ed943b9d4f8927196/pyannote_audio-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-python/hatchling-1.20"

RDEPEND="
	>=dev-python/asteroid-filterbanks-0.4[${PYTHON_USEDEP}]
	>=dev-python/einops-0.8[${PYTHON_USEDEP}]
	>=dev-python/huggingface-hub-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/lightning-2.4[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.10[${PYTHON_USEDEP}]
	>=dev-python/opentelemetry-api-1.27[${PYTHON_USEDEP}]
	>=dev-python/opentelemetry-exporter-otlp-1.27[${PYTHON_USEDEP}]
	>=dev-python/opentelemetry-sdk-1.27[${PYTHON_USEDEP}]
	>=dev-python/pyannote-core-6.0.1[${PYTHON_USEDEP}]
	>=dev-python/pyannote-database-6.1.1[${PYTHON_USEDEP}]
	>=dev-python/pyannote-metrics-4.0[${PYTHON_USEDEP}]
	>=dev-python/pyannote-pipeline-4.0[${PYTHON_USEDEP}]
	>=dev-python/pyannoteai-sdk-0.3[${PYTHON_USEDEP}]
	>=dev-python/pytorch-metric-learning-2.8[${PYTHON_USEDEP}]
	>=dev-python/rich-13.9.4[${PYTHON_USEDEP}]
	>=dev-python/safetensors-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/soundfile-0.13.1[${PYTHON_USEDEP}]
	>=dev-python/torch-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/torchaudio-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/torchcodec-0.7[${PYTHON_USEDEP}]
	>=dev-python/torchmetrics-1.6[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
