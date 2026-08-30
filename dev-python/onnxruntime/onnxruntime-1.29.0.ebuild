# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Cross-platform, high performance ONNX Model Runner (binary wheel)"
HOMEPAGE="https://onnxruntime.ai"

PY312_URL="https://files.pythonhosted.org/packages/96/eb/e6968f5e41aac3125f2ff5708855f09cb0b70d85ed3115b625b0b58305ba/onnxruntime-1.29.0-cp312-cp312-manylinux_2_28_x86_64.whl"
PY313_URL="https://files.pythonhosted.org/packages/83/2c/d8eb945d2a372149df9705a8d5c8d7c6c46c987c5446dbcea9e1ea7f6556/onnxruntime-1.29.0-cp313-cp313-manylinux_2_28_x86_64.whl"
PY314_URL="https://files.pythonhosted.org/packages/65/54/9f197c578d3d3d7bea16971e233e5483981228eec73748585cf7b5933403/onnxruntime-1.29.0-cp314-cp314-manylinux_2_28_x86_64.whl"
SRC_URI="
	python_targets_python3_12? ( ${PY312_URL} -> ${P}-cp312.whl.zip )
	python_targets_python3_13? ( ${PY313_URL} -> ${P}-cp313.whl.zip )
	python_targets_python3_14? ( ${PY314_URL} -> ${P}-cp314.whl.zip )
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
		unpack onnxruntime-1.29.0-cp312.whl.zip
	fi
	if use python_targets_python3_13; then
		mkdir -p "${WORKDIR}/python3.13" || die
		cd "${WORKDIR}/python3.13" || die
		unpack onnxruntime-1.29.0-cp313.whl.zip
	fi
	if use python_targets_python3_14; then
		mkdir -p "${WORKDIR}/python3.14" || die
		cd "${WORKDIR}/python3.14" || die
		unpack onnxruntime-1.29.0-cp314.whl.zip
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
