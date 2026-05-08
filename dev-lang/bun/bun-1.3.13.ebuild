# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: This is a skeleton ebuild for building Bun from source.
# Building Bun from source is complex and requires careful handling of:
# - Zig compiler (auto-downloaded by build scripts)
# - LLVM 21 (exact version enforced at runtime)
# - Circular bootstrap: Bun's build system uses Bun itself
# - JavaScriptCore/WebKit submodule (~2GB)
#
# For now, use dev-lang/bun-bin for a working installation.
# This ebuild is provided for future development toward a full
# source build.

DESCRIPTION="Fast all-in-one JavaScript runtime, bundler, transpiler, and package manager"
HOMEPAGE="https://bun.sh https://github.com/oven-sh/bun"
SRC_URI="https://github.com/oven-sh/bun/archive/refs/tags/bun-v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/bun-bun-v${PV}"

LICENSE="MIT LGPL-2"
SLOT="0"
# No KEYWORDS -- masked until source build is validated
IUSE="cpu_flags_x86_avx2"

# Build needs network for Zig toolchain download and git submodules
RESTRICT="network-sandbox test strip"

# LLVM 21 is required (exact match enforced by build system)
BDEPEND="
	dev-lang/bun-bin
	llvm-core/clang:21
	llvm-core/lld:21
	llvm-core/llvm:21
	dev-build/cmake
	dev-build/ninja
	dev-lang/go
	dev-lang/rust
	dev-ruby/rubygems
	dev-util/pkgconf
	sys-devel/automake
	sys-libs/libunwind
"
RDEPEND="
	dev-libs/icu
"

src_compile() {
	# Bun bootstraps itself: uses bun-bin to run the build scripts
	# which compile Bun from Zig/C++ source via LLVM
	export CC="clang-21"
	export CXX="clang++-21"

	einfo "Building Bun from source (this will take 10-30 minutes)..."
	bun run build || die "Bun source build failed"
}

src_install() {
	local bin="build/release/bun"
	[[ -x "${bin}" ]] || bin="build/bun"
	[[ -x "${bin}" ]] || die "compiled bun binary not found"

	dobin "${bin}"
	dosym bun /usr/bin/bunx
}

pkg_postinst() {
	einfo "Bun ${PV} installed (built from source)."
	einfo ""
	einfo "  bun init        -- scaffold a new project"
	einfo "  bun install     -- install dependencies"
	einfo "  bun run <file>  -- execute TypeScript/JavaScript"
	einfo "  bun build       -- bundle for production"
	einfo "  bunx <pkg>      -- execute a package (like npx)"
}
