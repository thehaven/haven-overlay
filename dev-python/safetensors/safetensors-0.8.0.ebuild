# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# safetensors 0.8.0 — build notes
# ------------------------------------------------------------------
# Build backend is maturin, which invokes cargo and pulls Rust crate
# dependencies from crates.io at build time. The sdist ships a
# Cargo.lock but does NOT vendor the crate sources, so a network
# fetch during src_compile is unavoidable. This is a documented
# exception to the gentoo-ebuild skill's vendoring rule, scoped to
# the safetensors 0.6.x series (the last release line that uses a
# simple three-crate Python binding; 0.7+ and 0.8+ add additional
# features and require a fuller Cargo workspace).
#
# safetensors 0.8.0 is self-contained at runtime: the only declared
# optional dependencies are downstream frameworks (numpy/torch/etc.)
# that consumers pull in via their own [extra]. No runtime RDEPEND
# is required from the safetensors package itself.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Simple, safe way to store and distribute tensors"
HOMEPAGE="https://github.com/huggingface/safetensors"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# maturin invokes cargo, which fetches crate dependencies from
# crates.io at build time. See the package-level comment block.
RESTRICT="network-sandbox"

BDEPEND=">=dev-util/maturin-1.8.2[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
