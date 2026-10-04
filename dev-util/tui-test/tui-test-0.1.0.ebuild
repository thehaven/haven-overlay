# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Gentoo PV cannot contain hyphens (only `_` separates version components
# and `-rN` denotes a Gentoo revision). Upstream tag is `0.1.0-beta.3`;
# convert `_beta` -> `-beta.` to recover the upstream tag.
MY_PV="${PV/_beta/-beta.}"

DESCRIPTION="Control, record, and test any TUI app or CLI with popular terminals"
HOMEPAGE="https://github.com/microsoft/tui-test"
SRC_URI="https://github.com/microsoft/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# tui-test-cli pulls the tui-test-rs library (workspace member
# `crates/tui-test`), 100+ transitive deps from crates.io, and a git-pinned
# `libghostty-vt` at https://github.com/Uzaaft/libghostty-rs (rev
# a28e4ad0...). No vendor tarball is shipped — cargo fetches at build time.
# network-sandbox OPENS network for this package (disables the default
# global sandbox; absence would block every cargo fetch with a sandbox
# violation). See AGENTS.md "Source-based Node.js / Bun policy" for the
# same pattern applied to JS/Bun builds.
RESTRICT="network-sandbox test strip"

# Workspace MSRV is 1.90 (Cargo.toml `[workspace.package] rust-version`).
# `libghostty-vt-sys`'s build.rs invokes `zig build` against the vendored
# Ghostty source it pulls at build time and refuses to run on any Zig
# before 0.16.0 (verified 2026-09-08 — system zig 0.15.2 dies with
# "Your Zig version v0.15.2 does not meet the required build version of
# v0.16.0"). dev-lang/zig-0.16.0 is ~amd64-keyworded and pulls LLVM 21
# (zig eclass; ~1 h build, 8 GB RAM), so this is a heavy dep — accept it
# only if you actually need the `ghostty` virtual-terminal backend. The
# CLI requires it; if upstream later makes the backend optional, gate
# this BDEPEND behind a USE flag.
BDEPEND="
	>=dev-lang/rust-1.90
	>=dev-lang/zig-0.16.0
"

src_compile() {
	# Build only the CLI crate; bindings/js and bindings/python/native are
	# workspace members but NOT in [workspace] default-members, so cargo
	# ignores them. --locked fails fast if Cargo.lock would need to be
	# regenerated (would imply upstream changed deps without bumping the
	# lockfile).
	cargo build --release -p tui-test-cli --locked || die
}

src_install() {
	dobin target/release/${PN}
	einstalldocs
}
