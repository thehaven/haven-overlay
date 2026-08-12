# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="renovate"

DESCRIPTION="Automated dependency updates. Flexible so you don't need to be."
HOMEPAGE="https://renovatebot.com"
SRC_URI="https://registry.npmjs.org/${NPM_PKG}/-/${NPM_PKG}-${PV}.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND="net-libs/nodejs"

src_compile() { :; }

src_install() {
	npm install --audit false --global --omit dev \
		--prefix "${ED}/usr" "${DISTDIR}/${P}.tgz" || die

	# Smoke test: both bins exist and are executable (catches the extract-only
	# anti-pattern — the 117 runtime deps must be resolved by npm, not declared
	# against unpackaged dev-nodejs/* atoms)
	local bindir="${ED}/usr/bin"
	for bin in renovate renovate-config-validator; do
		[[ -L "${bindir}/${bin}" ]] || die "/usr/bin/${bin} missing"
		[[ -x $(realpath "${bindir}/${bin}") ]] || die "/usr/bin/${bin} target not executable"
	done
}

pkg_postinst() {
	elog "Renovate ${PV} has been installed!"
	elog ""
	elog "To run Renovate locally or self-hosted, you typically need a platform token."
	elog "For GitHub:"
	elog "  export RENOVATE_TOKEN=ghp_your_personal_access_token"
	elog "  renovate --token \$RENOVATE_TOKEN your/repo"
	elog ""
	elog "For full documentation on self-hosting, see:"
	elog "  https://docs.renovatebot.com/self-hosted-configuration/"
	elog ""
	elog "Configuration files are usually named renovate.json or renovate.config.js."
	elog "To set a global cache directory (highly recommended):"
	elog "  export RENOVATE_CACHE_DIR=/var/cache/renovate"
}
