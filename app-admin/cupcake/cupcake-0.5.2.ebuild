# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo

DESCRIPTION="OPA/Rego policy enforcement layer for AI coding agents"
HOMEPAGE="https://github.com/eqtylab/cupcake"
SRC_URI="https://github.com/eqtylab/cupcake/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Upstream only publishes prebuilt binaries for some tags - v0.4.0 and v0.5.2
# exist as tags with no release - so build from the tag tarball, which is
# present for every version. The crates are fetched once from crates.io under
# the frozen Cargo.lock and vendored, so the compile itself stays offline.
# network-sandbox OPENS the network for src_unpack; the test suite needs opa
# and the Claude CLI, which are not packaged here.
RESTRICT="network-sandbox test"

BDEPEND=">=dev-lang/rust-1.86"

src_unpack() {
	cargo_src_unpack

	# cargo_src_unpack pins crates-io to the still empty vendor directory and
	# forces offline mode, so fetch through a scratch CARGO_HOME and populate
	# the vendor directory the eclass points at.
	local fetch_home="${WORKDIR}/cargo-fetch"
	mkdir -p "${fetch_home}" || die
	einfo "Fetching crates.io dependencies pinned by Cargo.lock"
	# Upstream ships a stale Cargo.lock (the workspace members are still
	# listed as 0.3.0 while the tag is 0.5.2), so cargo refuses to run with
	# --locked. Without it cargo only re-resolves the workspace members and
	# keeps every dependency version from the shipped lock.
	env CARGO_HOME="${fetch_home}" "${CARGO}" fetch \
		--manifest-path "${S}/Cargo.toml" || die
	env CARGO_HOME="${fetch_home}" "${CARGO}" vendor \
		--manifest-path "${S}/Cargo.toml" "${ECARGO_VENDOR}" || die
}

src_configure() {
	cargo_src_configure --bin cupcake
}

src_install() {
	dobin "${S}/target/release/cupcake"
	einstalldocs
}
