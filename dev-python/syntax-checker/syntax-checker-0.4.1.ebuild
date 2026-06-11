# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..15} )

CRATES="
	aho-corasick@1.1.4
	cc@1.2.62
	find-msvc-tools@0.1.9
	heck@0.5.0
	libc@0.2.186
	memchr@2.8.0
	once_cell@1.21.4
	portable-atomic@1.13.1
	proc-macro2@1.0.106
	pyo3-build-config@0.28.3
	pyo3-ffi@0.28.3
	pyo3-macros-backend@0.28.3
	pyo3-macros@0.28.3
	pyo3@0.28.3
	quote@1.0.45
	regex-automata@0.4.14
	regex-syntax@0.8.10
	regex@1.12.3
	shlex@1.3.0
	streaming-iterator@0.1.9
	syn@2.0.117
	target-lexicon@0.13.5
	tree-sitter-language@0.1.7
	tree-sitter@0.24.7
	unicode-ident@1.0.24
"

inherit cargo distutils-r1

DESCRIPTION="Syntax checker for shell scripts and other languages"
HOMEPAGE="https://github.com/rusiaaman/syntax-checker"
SRC_URI="https://github.com/rusiaaman/syntax-checker/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/tree-sitter
"
BDEPEND="
	dev-libs/tree-sitter
"
