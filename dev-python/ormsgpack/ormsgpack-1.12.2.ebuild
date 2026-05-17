EAPI=8
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..14} )

CRATES="
	ahash@0.8.12
	autocfg@1.5.0
	bytecount@0.6.9
	cfg-if@1.0.4
	chrono@0.4.44
	crunchy@0.2.4
	half@2.7.1
	itoa@1.0.18
	libc@0.2.186
	memoffset@0.9.1
	num-traits@0.2.19
	once_cell@1.21.4
	portable-atomic@1.13.1
	proc-macro2@1.0.106
	pyo3-build-config@0.27.2
	pyo3-ffi@0.27.2
	pyo3@0.27.2
	quote@1.0.45
	serde@1.0.228
	serde_bytes@0.11.19
	serde_core@1.0.228
	serde_derive@1.0.228
	simdutf8@0.1.5
	smallvec@1.15.1
	syn@2.0.117
	target-lexicon@0.13.5
	unicode-ident@1.0.24
	version_check@0.9.5
	zerocopy-derive@0.8.48
	zerocopy@0.8.48
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Fast Python MessagePack library"
HOMEPAGE="https://github.com/jason-kuo/ormsgpack"
SRC_URI="https://github.com/jason-kuo/ormsgpack/archive/refs/tags/v1.12.2.tar.gz -> ormsgpack-1.12.2.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/ormsgpack-1.12.2"

src_unpack() {
	unpack ormsgpack-1.12.2.tar.gz
	cargo_src_unpack
}
