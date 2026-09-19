# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="shfmt pre-commit hook definitions for the pre-commit / prek framework"
HOMEPAGE="https://github.com/scop/pre-commit-shfmt"

# Gentoo PV replaces the upstream tag's `-` patch suffix with `.` (PEP 440 /
# Portage convention), so PV=3.14.1.1 maps to upstream tag v3.14.1-1.
MY_UPSTREAM_TAG="3.14.1-1"

# The upstream Python wrapper is a pure bootstrap that downloads the shfmt
# binary at install time and installs a .pre-commit-hooks.yaml. On Gentoo we
# already ship `dev-util/shfmt` (the same upstream binary, mvdan/sh, versioned
# to match), so the meaningful artefact is the hooks.yaml — the wrapper
# itself has no runtime value.
SRC_URI="https://github.com/scop/pre-commit-shfmt/archive/refs/tags/v${MY_UPSTREAM_TAG}.tar.gz
	-> ${P}.gh.tar.gz"

S="${WORKDIR}/${PN}-${MY_UPSTREAM_TAG}"

LICENSE="BSD Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# dev-util/shfmt is the binary the pre-commit hooks invoke (`entry: shfmt`
# in .pre-commit-hooks.yaml). Installing this package without dev-util/shfmt
# would leave the hooks unable to run.
RDEPEND="dev-util/shfmt"

# BSD-3-Clause applies to setup.py + README content; Apache-2.0 covers the
# bundled setuptools-download glue; MIT is for the upstream copy/paste from
# shellcheck-py.
RESTRICT="mirror"

src_install() {
	# Install the pre-commit hook definitions where downstream tooling can
	# find them. The upstream Python wrapper exists only to deliver this
	# single file; Gentoo consumes the binary directly via dev-util/shfmt
	# (see RDEPEND), so we skip the wrapper entirely.
	insinto /usr/share/${PN}
	newins .pre-commit-hooks.yaml hooks.yaml
}

pkg_postinst() {
	einfo "pre-commit-shfmt ${PV} hook definitions installed."
	einfo "Hook config: /usr/share/${PN}/hooks.yaml"
	einfo "Binary used by the hook: \$(command -v shfmt) (from dev-util/shfmt)"
}
