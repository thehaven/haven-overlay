# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Pinned to the main-branch commit at the time of packaging; upstream
# has no tagged release. Bump with `cargo ebuild` and a `git describe`
# once a release is tagged.
EAPI=8

CRATES="
	aho-corasick@1.0.1
	autocfg@1.1.0
	base64@0.21.0
	bitflags@1.3.2
	bumpalo@3.12.2
	bytes@1.4.0
	cc@1.0.79
	cfg-if@1.0.0
	core-foundation-sys@0.8.4
	core-foundation@0.9.3
	encoding_rs@0.8.32
	errno-dragonfly@0.1.2
	errno@0.3.1
	fastrand@1.9.0
	fnv@1.0.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.1.0
	futures-channel@0.3.28
	futures-core@0.3.28
	futures-io@0.3.28
	futures-sink@0.3.28
	futures-task@0.3.28
	futures-util@0.3.28
	h2@0.3.19
	hashbrown@0.12.3
	hermit-abi@0.2.6
	hermit-abi@0.3.1
	http-body@0.4.5
	http@0.2.9
	httparse@1.8.0
	httpdate@1.0.2
	hyper-tls@0.5.0
	hyper@0.14.26
	idna@0.3.0
	indexmap@1.9.3
	instant@0.1.12
	io-lifetimes@1.0.10
	ipnet@2.7.2
	itoa@1.0.6
	js-sys@0.3.63
	lazy_static@1.4.0
	libc@0.2.144
	linux-raw-sys@0.3.7
	log@0.4.17
	memchr@2.5.0
	mime@0.3.17
	mio@0.8.6
	native-tls@0.2.11
	num_cpus@1.15.0
	once_cell@1.17.1
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-sys@0.9.87
	openssl@0.10.52
	percent-encoding@2.2.0
	pin-project-lite@0.2.9
	pin-utils@0.1.0
	pkg-config@0.3.27
	proc-macro2@1.0.57
	quote@1.0.27
	redox_syscall@0.3.5
	regex-syntax@0.7.1
	regex@1.8.1
	reqwest@0.11.18
	rustix@0.37.19
	ryu@1.0.13
	same-file@1.0.6
	schannel@0.1.21
	security-framework-sys@2.9.0
	security-framework@2.9.0
	serde@1.0.163
	serde_derive@1.0.163
	serde_json@1.0.96
	serde_urlencoded@0.7.1
	serde_yaml@0.9.21
	slab@0.4.8
	socket2@0.4.9
	syn@2.0.16
	tempfile@3.5.0
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio-native-tls@0.3.1
	tokio-util@0.7.8
	tokio@1.28.1
	tower-service@0.3.2
	tracing-core@0.1.31
	tracing@0.1.37
	try-lock@0.2.4
	unicode-bidi@0.3.13
	unicode-ident@1.0.8
	unicode-normalization@0.1.22
	unsafe-libyaml@0.2.8
	url@2.3.1
	vcpkg@0.2.15
	walkdir@2.3.3
	want@0.3.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.86
	wasm-bindgen-futures@0.4.36
	wasm-bindgen-macro-support@0.2.86
	wasm-bindgen-macro@0.2.86
	wasm-bindgen-shared@0.2.86
	wasm-bindgen@0.2.86
	web-sys@0.3.63
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.42.0
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-targets@0.42.2
	windows-targets@0.48.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.0
	winreg@0.10.1
"

inherit cargo

DESCRIPTION="Rust library to detect programming languages (linguist-rs)"
HOMEPAGE="https://github.com/adiepenbrock/linguist-rs"
SRC_URI="
	https://github.com/adiepenbrock/linguist-rs/archive/d44d71dd1ac99de78a28ef2e01258d36195b1981.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

# linguist-rs is the main workspace member (a Rust library). The workspace
# also builds linguist-build (a build.rs helper) and examples; cargo
# resolves those when building the main member, so no separate ebuild.
# GitHub commit-sha archives extract to <repo>-<fullsha>/, not to ${P};
# pin the commit literal so the path matches the upstream tarball.
S="${WORKDIR}/linguist-rs-d44d71dd1ac99de78a28ef2e01258d36195b1981/linguist"

LICENSE="MIT Apache-2.0 BSD MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	# Override cargo_src_install: linguist-rs is a library-only crate (no
	# bin or example target), so `cargo install` finds nothing to install.
	# For a Rust library the canonical Gentoo pattern is to publish to
	# crates.io; since upstream has not, we install the source tree +
	# Cargo.toml so downstream cargo users can pick it up via a
	# `path = "/usr/share/cargo/<pkg>/<ver>"` dependency. The compiled
	# .rlib is rebuilt downstream from the installed source.
	local module_dir="/usr/share/cargo/${PN}/${PV}"
	insinto "${module_dir}"
	# Cargo.lock and LICENSE live in the workspace root (one level up from
	# this member), not in S — only the member's src tree and Cargo.toml
	# are installable here. Downstream cargo users get a fresh Cargo.lock
	# on next `cargo build` from the installed path.
	doins -r src
	doins Cargo.toml
}

pkg_postinst() {
	einfo "linguist-rs is a Rust library for detecting programming"
	einfo "languages from text blobs. It is not a binary; downstream Rust"
	einfo "projects can depend on it via cargo by adding the git repo as a"
	einfo "path/git dependency, or after linguist-rs is published to"
	einfo "crates.io via a regular versioned dependency."
}
