# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Cross-platform, high performance ONNX Model Runner (binary wheel)"
HOMEPAGE="https://onnxruntime.ai"

PY312_URL="https://files.pythonhosted.org/packages/eb/27/c6a823bac55b2977bea2027c3ec9393a2c1002cb9a09eb40354563e02730/onnxruntime-1.31.1-cp312-cp312-manylinux_2_28_x86_64.whl"
PY313_URL="https://files.pythonhosted.org/packages/fc/0a/c887bcb84a9455b2723825381a77af38611a80f996f804e20fde5f671b63/onnxruntime-1.31.1-cp313-cp313-manylinux_2_28_x86_64.whl"
PY314_URL="https://files.pythonhosted.org/packages/aa/74/a891a659ccc427469de0d7bdbd5ff770a35f73084ee590ce02456cf61f7f/onnxruntime-1.31.1-cp314-cp314-manylinux_2_28_x86_64.whl"
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
		unpack onnxruntime-1.31.1-cp312.whl.zip
	fi
	if use python_targets_python3_13; then
		mkdir -p "${WORKDIR}/python3.13" || die
		cd "${WORKDIR}/python3.13" || die
		unpack onnxruntime-1.31.1-cp313.whl.zip
	fi
	if use python_targets_python3_14; then
		mkdir -p "${WORKDIR}/python3.14" || die
		cd "${WORKDIR}/python3.14" || die
		unpack onnxruntime-1.31.1-cp314.whl.zip
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
