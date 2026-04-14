# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="codex"
NPM_BASE="https://registry.npmjs.org/@openai/codex/-/codex"

DESCRIPTION="OpenAI Codex CLI - lightweight agentic coding agent"
HOMEPAGE="https://github.com/openai/codex"
SRC_URI="
	${NPM_BASE}-${PV}.tgz -> ${MY_PN}-${PV}.tgz
	amd64? ( ${NPM_BASE}-${PV}-linux-x64.tgz -> ${MY_PN}-${PV}-linux-x64.tgz )
	arm64? ( ${NPM_BASE}-${PV}-linux-arm64.tgz -> ${MY_PN}-${PV}-linux-arm64.tgz )
"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="bindist strip"

RDEPEND="
	>=net-libs/nodejs-22
	sys-apps/ripgrep
"

QA_PREBUILT="opt/codex/vendor/*/codex/codex"

src_compile() {
	:
}

src_install() {
	# The wrapper package unpacks first (into ${WORKDIR}/package),
	# then the platform package overwrites into the same dir.
	# After extraction both tarballs dump into ${WORKDIR}/package/.
	local pkg="${WORKDIR}/package"

	dodoc "${pkg}"/README.md

	insinto /opt/${MY_PN}
	doins -r "${pkg}"/bin
	fperms a+x /opt/${MY_PN}/bin/codex.js

	# Install platform-specific native binary
	insinto /opt/${MY_PN}
	doins -r "${pkg}"/vendor
	local triple
	if use amd64; then
		triple="x86_64-unknown-linux-musl"
	elif use arm64; then
		triple="aarch64-unknown-linux-musl"
	fi
	fperms a+x "/opt/${MY_PN}/vendor/${triple}/codex/codex"

	# Use system ripgrep instead of bundled
	rm -f "${ED}/opt/${MY_PN}/vendor/${triple}/path/rg" || true
	dosym -r /usr/bin/rg "/opt/${MY_PN}/vendor/${triple}/path/rg"

	dodir /opt/bin
	dosym -r /opt/${MY_PN}/bin/codex.js /opt/bin/codex
}

pkg_postinst() {
	einfo "OpenAI Codex CLI installed as 'codex'."
	einfo "Requires OPENAI_API_KEY environment variable."
	einfo "Usage: codex \"describe your task\""
	einfo "See https://github.com/openai/codex for documentation."
}
