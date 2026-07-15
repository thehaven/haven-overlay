# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# torchaudio — wheel-install notes
# ------------------------------------------------------------------
# PyPI hosts the official manylinux x86_64 wheels (cp310..cp314). PyTorch
# does not publish an sdist for stable releases; the GitHub tag is the
# only source tree and is not practical to build under Portage.
#
# download.pytorch.org (the alternate wheel host) is currently geo-fenced
# from this build host (403 to file GETs), so we use the PyPI mirrors here.
# Pinned URLs verified reachable via HEAD/GET on files.pythonhosted.org.
#
# cp315 reuses the cp314 wheel: ABI-compatible forward, and torchaudio
# 2.11.0 does not publish a cp315 build.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="Audio signal processing for PyTorch"
HOMEPAGE="https://pytorch.org/audio/ https://pypi.org/project/torchaudio/"

SRC_URI="
	python_targets_python3_12? (
		https://files.pythonhosted.org/packages/88/d8/d6d0f896e064aa67377484efef4911cdcc07bce2929474e1417cc0af18c2/torchaudio-${PV}-cp312-cp312-manylinux_2_28_x86_64.whl
		-> ${P}-cp312.whl.zip
	)
	python_targets_python3_13? (
		https://files.pythonhosted.org/packages/4f/98/be13fe35d9aa5c26381c0e453c828a789d15c007f8f7d08c95341d19974d/torchaudio-${PV}-cp313-cp313-manylinux_2_28_x86_64.whl
		-> ${P}-cp313.whl.zip
	)
	python_targets_python3_14? (
		https://files.pythonhosted.org/packages/a8/a8/bf2e1f6ce24c990192400ae49b4acc1a0d0295b6c6a06bceecdc46ce08de/torchaudio-${PV}-cp314-cp314-manylinux_2_28_x86_64.whl
		-> ${P}-cp314.whl.zip
	)
	python_targets_python3_15? (
		https://files.pythonhosted.org/packages/a8/a8/bf2e1f6ce24c990192400ae49b4acc1a0d0295b6c6a06bceecdc46ce08de/torchaudio-${PV}-cp314-cp314-manylinux_2_28_x86_64.whl
		-> ${P}-cp315.whl.zip
	)
"

S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
# bindist: the manylinux x86_64 wheel is a redistributable binary, but
# PyTorch's licensing/CLA posture and the per-(cp, arch) footprint make
# mirroring into ::gentoo impractical. Distribution via overlay-local
# distfiles only.
RESTRICT="bindist"

BDEPEND="app-arch/unzip"

# C++ extension with native code; no local compilation occurs.
QA_FLAGS_IGNORED=".*"

# Runtime deps: this wheel requires torch >= 2.10 (cp314 wheel torch is
# 2.11 but ABI-compatible with 2.10). The overlay ships torch-2.10.0.
RDEPEND="
	>=dev-python/torch-2.10[${PYTHON_USEDEP}]
"

src_unpack() {
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
}

src_compile() {
	:
}

python_install() {
	local sitedir
	sitedir=$(python_get_sitedir)
	insinto "${sitedir}"
	cd "${WORKDIR}/${EPYTHON}" || die
	doins -r torchaudio
	doins -r "${P}.dist-info"
}

src_install() {
	distutils-r1_src_install
}
