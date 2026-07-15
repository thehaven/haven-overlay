# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="pydantic_core"
inherit distutils-r1 pypi

DESCRIPTION="Core functionality for Pydantic validation and serialization"
HOMEPAGE="https://github.com/pydantic/pydantic-core"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# RESTRICT="network-sandbox" is not in the standard list; pkgcheck flags it as
# UnknownRestrict. Kept intentionally because maturin fetches crates from
# crates.io at build time. The gentoo-ebuild skill lists network-sandbox under
# "OVERLAY PRAGMATIC APPROACH" for Go; this applies analogously to maturin /
# Rust builds that need to populate Cargo.lock against upstream crate sources.
RESTRICT="network-sandbox"

BDEPEND=">=dev-util/maturin-1.0"
RDEPEND=">=dev-python/typing-extensions-4.6[${PYTHON_USEDEP}]"
