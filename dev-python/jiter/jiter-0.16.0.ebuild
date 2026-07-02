# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..14} )
RUST_MIN_VER="1.82.0"

CRATES="
	ahash@0.8.12
	aho-corasick@1.1.4
	anes@0.1.6
	anstyle@1.0.14
	autocfg@1.5.1
	bitflags@2.13.0
	bit-set@0.8.0
	bit-vec@0.8.0
	bitvec@1.1.1
	bumpalo@3.20.3
	cast@0.3.0
	cfg-if@1.0.4
	ciborium@0.2.2
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	clap@4.6.1
	clap_builder@4.6.0
	clap_lex@1.1.0
	codspeed@2.10.1
	codspeed-criterion-compat@2.10.1
	codspeed-criterion-compat-walltime@2.10.1
	colored@2.2.0
	criterion-plot@0.5.0
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crunchy@0.2.4
	either@1.16.0
	equivalent@1.0.2
	errno@0.3.14
	fastrand@2.4.1
	fnv@1.0.7
	funty@2.0.0
	futures-core@0.3.32
	futures-task@0.3.32
	futures-util@0.3.32
	getrandom@0.3.4
	getrandom@0.4.3
	half@2.7.1
	hashbrown@0.17.1
	heck@0.5.0
	hermit-abi@0.5.2
	indexmap@2.14.0
	is-terminal@0.4.17
	itertools@0.10.5
	itoa@1.0.18
	js-sys@0.3.103
	lazy_static@1.5.0
	lexical-parse-float@1.0.6
	lexical-parse-integer@1.0.6
	lexical-util@1.0.7
	libc@0.2.186
	linux-raw-sys@0.12.1
	memchr@2.8.2
	num-bigint@0.4.6
	num-integer@0.1.46
	num-traits@0.2.19
	once_cell@1.21.4
	oorandom@11.1.5
	paste@1.0.15
	pin-project-lite@0.2.17
	plotters@0.3.7
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	portable-atomic@1.13.1
	ppv-lite86@0.2.21
	proc-macro2@1.0.106
	proptest@1.11.0
	pyo3@0.29.0
	pyo3-build-config@0.29.0
	pyo3-ffi@0.29.0
	pyo3-macros@0.29.0
	pyo3-macros-backend@0.29.0
	quick-error@1.2.3
	quote@1.0.46
	radium@0.7.0
	rand@0.9.4
	rand_chacha@0.9.0
	rand_core@0.9.5
	rand_xorshift@0.4.0
	rayon@1.12.0
	rayon-core@1.13.0
	r-efi@5.3.0
	r-efi@6.0.0
	regex@1.12.4
	regex-automata@0.4.14
	regex-syntax@0.8.11
	rustix@1.1.4
	rustversion@1.0.22
	rusty-fork@0.3.1
	same-file@1.0.6
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.150
	slab@0.4.12
	smallvec@1.15.2
	syn@2.0.118
	tap@1.0.1
	target-lexicon@0.13.5
	tempfile@3.27.0
	tinytemplate@1.2.1
	unarray@0.1.4
	unicode-ident@1.0.24
	uuid@1.23.4
	version_check@0.9.5
	wait-timeout@0.2.1
	walkdir@2.5.0
	wasip2@1.0.4+wasi-0.2.12
	wasm-bindgen@0.2.126
	wasm-bindgen-macro@0.2.126
	wasm-bindgen-macro-support@0.2.126
	wasm-bindgen-shared@0.2.126
	web-sys@0.3.103
	winapi-util@0.1.11
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows-link@0.2.1
	windows-sys@0.59.0
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	wit-bindgen@0.57.1
	wyz@0.5.1
	zerocopy@0.8.52
	zerocopy-derive@0.8.52
	zmij@1.0.21"

inherit cargo distutils-r1 pypi

DESCRIPTION="Fast iterable JSON parser"
HOMEPAGE="https://github.com/pydantic/jiter"
SRC_URI+="
	${CARGO_CRATE_URIS}"

LICENSE="Apache-2.0 Boost-1.0 Apache-2.0-with-LLVM-exceptions MIT MPL-2.0 UoI-NCSA Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"
#RESTRICT="test"  # upstream tests need nodejs; our src_test validates CRATES

RDEPEND="dev-python/orjson[${PYTHON_USEDEP}]
	dev-python/ujson[${PYTHON_USEDEP}]"
BDEPEND="dev-util/maturin[${PYTHON_USEDEP}]"

QA_FLAGS_IGNORED="usr/lib/python.*/site-packages/jiter/jiter.*.so"

src_test() {
	einfo "Validating CRATES against upstream Cargo.lock"

	# Parse Cargo.lock into name@version pairs using grep + paste
	# Registry crates have a source=registry line right after name/version
	local lock_crates
	lock_crates=$(tar xzf "${DISTDIR}/${P}.tar.gz" --wildcards -O '*/Cargo.lock' 2>/dev/null \
		| grep -B2 'source = "registry' \
		| grep -E '^(name|version) = ' \
		| sed 's/^name = "//;s/^version = "//;s/"$//' \
		| paste - - \
		| while read -r name ver; do printf '%s@%s\n' "$name" "$ver"; done \
		| sort) || die "Failed to parse Cargo.lock"

	# Parse CRATES variable from ebuild
	local ebuild_crates
	ebuild_crates=$(echo "${CRATES}" | tr -d '"\t' | grep '@' | sort)

	if [[ -z "${lock_crates}" ]]; then
		die "No registry crates found in Cargo.lock"
	fi

	# Compare with comm (nix diff)
	local missing extra
	missing=$(comm -23 <(echo "${lock_crates}") <(echo "${ebuild_crates}"))
	extra=$(comm -13 <(echo "${lock_crates}") <(echo "${ebuild_crates}"))

	local mismatched=0
	if [[ -n "${missing}" ]]; then
		eerror "MISSING from ebuild CRATES (in Cargo.lock but not in ebuild):"
		eerror "${missing}"
		mismatched=1
	fi
	if [[ -n "${extra}" ]]; then
		eerror "EXTRA in ebuild CRATES (in ebuild but not in Cargo.lock):"
		eerror "${extra}"
		mismatched=1
	fi

	if [[ ${mismatched} -eq 1 ]]; then
		die "CRATES list out of sync (above). Regenerate: pycargoebuild ${PN}"
	fi
	einfo "CRATES list matches Cargo.lock"
}
