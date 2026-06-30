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
	anyhow@1.0.102
	autocfg@1.5.0
	bitflags@2.11.1
	bitvec@1.0.1
	bumpalo@3.20.2
	cast@0.3.0
	cc@1.2.62
	cfg-if@1.0.4
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.6.1
	clap_builder@4.6.0
	clap_lex@1.1.0
	codspeed-criterion-compat-walltime@2.10.1
	codspeed-criterion-compat@2.10.1
	codspeed@2.10.1
	colored@2.2.0
	criterion-plot@0.5.0
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crunchy@0.2.4
	either@1.15.0
	equivalent@1.0.2
	find-msvc-tools@0.1.9
	foldhash@0.1.5
	funty@2.0.0
	futures-core@0.3.32
	futures-task@0.3.32
	futures-util@0.3.32
	getrandom@0.3.4
	getrandom@0.4.2
	half@2.7.1
	hashbrown@0.15.5
	hashbrown@0.17.1
	heck@0.5.0
	hermit-abi@0.5.2
	id-arena@2.3.0
	indexmap@2.14.0
	is-terminal@0.4.17
	itertools@0.10.5
	itoa@1.0.18
	js-sys@0.3.98
	lazy_static@1.5.0
	leb128fmt@0.1.0
	lexical-parse-float@1.0.6
	lexical-parse-integer@1.0.6
	lexical-util@1.0.7
	libc@0.2.186
	log@0.4.29
	memchr@2.8.0
	num-bigint@0.4.6
	num-integer@0.1.46
	num-traits@0.2.19
	once_cell@1.21.4
	oorandom@11.1.5
	paste@1.0.15
	pin-project-lite@0.2.17
	plotters-backend@0.3.7
	plotters-svg@0.3.7
	plotters@0.3.7
	portable-atomic@1.13.1
	prettyplease@0.2.37
	proc-macro2@1.0.106
	pyo3-build-config@0.28.3
	pyo3-ffi@0.28.3
	pyo3-macros-backend@0.28.3
	pyo3-macros@0.28.3
	pyo3@0.28.3
	python3-dll-a@0.2.15
	quote@1.0.45
	r-efi@5.3.0
	r-efi@6.0.0
	radium@0.7.0
	rayon-core@1.13.0
	rayon@1.12.0
	regex-automata@0.4.14
	regex-syntax@0.8.10
	regex@1.12.3
	rustversion@1.0.22
	same-file@1.0.6
	semver@1.0.28
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	shlex@1.3.0
	slab@0.4.12
	smallvec@1.15.1
	syn@2.0.117
	tap@1.0.1
	target-lexicon@0.13.5
	tinytemplate@1.2.1
	unicode-ident@1.0.24
	unicode-xid@0.2.6
	uuid@1.23.1
	version_check@0.9.5
	walkdir@2.5.0
	wasip2@1.0.3+wasi-0.2.9
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-bindgen-macro-support@0.2.121
	wasm-bindgen-macro@0.2.121
	wasm-bindgen-shared@0.2.121
	wasm-bindgen@0.2.121
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	web-sys@0.3.98
	winapi-util@0.1.11
	windows-link@0.2.1
	windows-sys@0.59.0
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.51.0
	wit-bindgen@0.57.1
	wit-component@0.244.0
	wit-parser@0.244.0
	wyz@0.5.1
	zerocopy-derive@0.8.48
	zerocopy@0.8.48
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
