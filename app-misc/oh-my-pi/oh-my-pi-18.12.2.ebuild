# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BUN_SLOT="1.3"

inherit bun

DESCRIPTION="AI coding agent CLI with a terminal UI and session management"
HOMEPAGE="https://omp.sh https://github.com/can1357/oh-my-pi"
SRC_URI="
	https://github.com/can1357/oh-my-pi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/oh-my-pi-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
# network-sandbox is REQUIRED here and it OPENS the network for build phases:
# it disables the default FEATURES=network-sandbox for this package rather than
# restricting anything. `bun install` pulls the JS workspace dependencies from
# the npm registry and cargo fetches the crates pinned in Cargo.lock; with the
# sandbox left on both die on the first connection.
# test: upstream's suite is not wired up for this package.
# strip: the final artifact is a Bun standalone executable; stripping it is not
# meaningful and can corrupt the embedded runtime blob.
RESTRICT="network-sandbox test strip"

RDEPEND="
	app-arch/unzip
	app-misc/ca-certificates
	dev-db/sqlite
	dev-vcs/git
	net-misc/curl
	net-misc/openssh
	!app-misc/oh-my-pi-bin
"

BDEPEND="
	dev-build/cmake
	dev-build/ninja
	virtual/pkgconfig
	|| (
		>=dev-lang/rust-1.97
		>=dev-lang/rust-bin-1.97
	)
"

src_compile() {
	bun_setup

	# crates/* (including the pi-natives N-API addon) is compiled by
	# @napi-rs/cli through packages/natives' `build` script. Its `host`
	# pseudo-target takes the local Cargo/N-API path with the host toolchain --
	# Bazel is not involved.
	#
	# Upstream pins rust-toolchain.toml to a nightly, but the tree only uses
	# two nightly-only items:
	#   * #![feature(alloc_error_hook)] in crates/pi-natives/src/lib.rs
	#   * Option::map_or_default (result_option_map_or_default) in a few crates
	# plus the `embed-metadata` unstable cargo option in .cargo/config.toml,
	# which stable cargo only warns about. RUSTC_BOOTSTRAP=1 lets the stable
	# toolchain accept nightly features, and -Z crate-attr injects the missing
	# feature gate into every crate root; -A unused-features silences the
	# "feature not used" warnings that the blanket crate-attr produces.
	# Same approach as ::gentoo's dev-util/bpf-linker and dev-util/bingrep.
	# If upstream starts using a newer nightly-only feature, extend the
	# RUSTFLAGS feature list or move to a real nightly toolchain.
	export RUSTC_BOOTSTRAP=1
	export RUSTFLAGS="-Z crate-attr=feature(result_option_map_or_default)"
	RUSTFLAGS+=" -A unused-features"

	# Keep cargo's registry cache out of the build HOME (Portage points HOME at
	# ${PORTAGE_BUILDDIR}/homedir) so the download location is explicit.
	export CARGO_HOME="${T}/cargo-home"

	# CROSS_TARGET switches build-binary.ts to a cross-compile that pulls a
	# target-specific Bun runtime; unset means a host compile, which is what a
	# distribution package wants.
	unset CROSS_TARGET

	einfo "Installing JS workspace dependencies with bun..."
	bun install --frozen-lockfile --ignore-scripts || die "bun install failed"

	einfo "Building the pi-natives N-API addon (host target)..."
	bun --cwd=packages/natives run build || die "pi-natives build failed"

	einfo "Compiling the standalone omp binary..."
	bun --cwd=packages/coding-agent run build || die "omp compilation failed"
}

src_install() {
	# build-binary.ts emits packages/coding-agent/dist/omp for host builds.
	[[ -x packages/coding-agent/dist/omp ]] || die "compiled binary not found"
	newbin packages/coding-agent/dist/omp omp

	# The standalone embeds several hundred npm packages and the compiled
	# crates, so upstream's own dependency-licence aggregate is the accurate
	# licence statement for what actually ships here, not just LICENSE.
	dodoc LICENSE THIRD-PARTY-NOTICES.txt
}

pkg_postinst() {
	einfo "omp ${PV} installed (built from source with Bun and cargo)."
	einfo ""
	einfo "On first use omp downloads its ML runtime (@huggingface/transformers,"
	einfo "fastembed, onnxruntime-node) into a per-user cache; upstream keeps"
	einfo "those packages external on purpose rather than bundling them."
	einfo ""
	if ! has_version "net-libs/nodejs"; then
		elog "omp can launch MCP servers distributed as npm packages, which"
		elog "needs node/npx: emerge net-libs/nodejs"
	fi
	if ! has_version "dev-lang/bun"; then
		elog "Installing omp plugins and skills shells out to bun:"
		elog "emerge dev-lang/bun"
	fi
	einfo ""
	einfo "See 'omp --help' for the available commands."
}
