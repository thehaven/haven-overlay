# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="Cross-platform, high performance ONNX Model Runner (binary wheel)"
HOMEPAGE="https://onnxruntime.ai"

SRC_URI="
        python_targets_python3_11? ( https://files.pythonhosted.org/packages/b6/3f/8de630f595daf6ce884d4dd95afd2a60e70ec6572e52bfee3aa2229befab/onnxruntime-1.26.0-cp311-cp311-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl -> onnxruntime-1.26.0-cp311.whl.zip )
        python_targets_python3_12? ( https://files.pythonhosted.org/packages/7c/43/2a4e04f8dbeffad19bbcced4bcd4289bf478921518437404d6b92bdf213b/onnxruntime-1.26.0-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl -> onnxruntime-1.26.0-cp312.whl.zip )
        python_targets_python3_13? ( https://files.pythonhosted.org/packages/3d/26/4d09ddc755a84fc8d5e192991626b0e0680e8f6c5d58f4f1d05c42bc48cf/onnxruntime-1.26.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl -> onnxruntime-1.26.0-cp313.whl.zip )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
        if use python_targets_python3_11; then
                mkdir -p "${WORKDIR}/python3.11" || die
                cd "${WORKDIR}/python3.11" || die
                unpack onnxruntime-1.26.0-cp311.whl.zip
        fi
        if use python_targets_python3_12; then
                mkdir -p "${WORKDIR}/python3.12" || die
                cd "${WORKDIR}/python3.12" || die
                unpack onnxruntime-1.26.0-cp312.whl.zip
        fi
        if use python_targets_python3_13; then
                mkdir -p "${WORKDIR}/python3.13" || die
                cd "${WORKDIR}/python3.13" || die
                unpack onnxruntime-1.26.0-cp313.whl.zip
        fi
}

src_compile() {
        :
}

python_install() {
        insinto "$(python_get_sitedir)"
        cd "${WORKDIR}/${EPYTHON}" || die
        doins -r onnxruntime
        doins -r onnxruntime-*.dist-info
}

src_install() {
        distutils-r1_src_install
}
