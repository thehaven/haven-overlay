# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="Cross-platform, high performance ONNX Model Runner (binary wheel)"
HOMEPAGE="https://onnxruntime.ai"

SRC_URI="
	python_targets_python3_12? ( https://files.pythonhosted.org/packages/6d/ab/5b68110e0460d73fad814d5bd11c7b1ddcce5c37b10177eb264d6a36e331/${P}-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl -> ${P}-cp312.whl.zip )
	python_targets_python3_13? ( https://files.pythonhosted.org/packages/7f/72/105ec27a78c5aa0154a7c0cd8c41c19a97799c3b12fc30392928997e3be3/${P}-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl -> ${P}-cp313.whl.zip )
	python_targets_python3_14? ( https://files.pythonhosted.org/packages/5f/ba/4699cde04a52cece66cbebc85bd8335a0d3b9ad485abc9a2e15946a1349d/${P}-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl -> ${P}-cp314.whl.zip )
	python_targets_python3_15? ( https://files.pythonhosted.org/packages/5f/ba/4699cde04a52cece66cbebc85bd8335a0d3b9ad485abc9a2e15946a1349d/${P}-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl -> ${P}-cp315.whl.zip )
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"

QA_FLAGS_IGNORED=".*"

src_unpack() {
	if use python_targets_python3_12; then
		mkdir -p "${WORKDIR}/python3.12" || die
		cd "${WORKDIR}/python3.12" || die
		unpack onnxruntime-1.24.4-cp312.whl.zip
	fi
	if use python_targets_python3_13; then
		mkdir -p "${WORKDIR}/python3.13" || die
		cd "${WORKDIR}/python3.13" || die
		unpack onnxruntime-1.24.4-cp313.whl.zip
	fi
	if use python_targets_python3_14; then
		mkdir -p "${WORKDIR}/python3.14" || die
		cd "${WORKDIR}/python3.14" || die
		unpack onnxruntime-1.24.4-cp314.whl.zip
	fi
	if use python_targets_python3_15; then
		mkdir -p "${WORKDIR}/python3.15" || die
		cd "${WORKDIR}/python3.15" || die
		unpack onnxruntime-1.24.4-cp315.whl.zip
	fi
}

src_compile() {
	:
}

python_install() {
	local sitedir=$(python_get_sitedir)
	insinto "${sitedir}"
	cd "${WORKDIR}/${EPYTHON}" || die
	doins -r onnxruntime
	doins -r onnxruntime-*.dist-info
}

src_install() {
	distutils-r1_src_install
}
