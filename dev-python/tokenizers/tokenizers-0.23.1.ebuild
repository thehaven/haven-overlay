# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Fast tokenization for NLP models"
HOMEPAGE="https://github.com/huggingface/tokenizers"
SRC_URI="https://github.com/huggingface/tokenizers/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
S="${WORKDIR}/${P}"
KEYWORDS="~amd64"

DEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" -m unittest discover -s tests || die "Tests failed with ${EPYTHON}"
}

pkg_postinst() {
	einfo "Tokenizers installed successfully!"
	einfo ""
	einfo "Tokenizers is an implementation of modern tokenizers, including"
	einfo "the Byte-Pair Encoding (BPE) algorithm, WordPiece, and Unigram."
	einfo "It provides fast and efficient tokenization for NLP models."
	einfo ""
	einfo "Features:"
	einfo "  - Fast tokenization (Rust implementation)"
	einfo "  - Multiple tokenization algorithms"
	einfo "  - Pre-trained tokenizer support"
	einfo "  - Compatible with Hugging Face ecosystem"
	einfo ""
	einfo "For more information, see the project documentation at:"
	einfo "  https://github.com/huggingface/tokenizers"
}
