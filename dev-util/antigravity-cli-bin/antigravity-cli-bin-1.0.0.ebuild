# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Google Antigravity CLI - Unified agentic terminal platform"
HOMEPAGE="https://antigravity.google"

# Manifest URL: https://antigravity-cli-auto-updater-974169037036.us-central1.run.app/manifests/linux_${ARCH}.json
# Version 1.0.0 ID: 5288553236791296
BASE_URI="https://storage.googleapis.com/antigravity-public/antigravity-cli/1.0.0-5288553236791296"
SRC_URI="
	amd64? ( ${BASE_URI}/linux-x64/cli_linux_x64.tar.gz -> ${PN}-${PV}-amd64.tar.gz )
	arm64? ( ${BASE_URI}/linux-arm/cli_linux_arm64.tar.gz -> ${PN}-${PV}-arm64.tar.gz )
"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
IUSE=""

RDEPEND="
	!!dev-util/gemini-cli
"

S="${WORKDIR}"

QA_PREBUILT="usr/bin/agy"

src_install() {
	newbin antigravity agy
	
	# Provide gemini symlink for backward compatibility during transition
	dosym agy /usr/bin/gemini
}

pkg_postinst() {
	elog "Google Antigravity CLI (agy) has been installed."
	elog "This package replaces gemini-cli as part of the unification effort."
	elog ""
	elog "To migrate your existing Gemini extensions to Antigravity plugins, run:"
	elog "  agy plugin import gemini"
	elog ""
	elog "A 'gemini' symlink has been provided for backward compatibility."
	elog "Please refer to the migration guide for more details:"
	elog "https://antigravity.google/docs/gcli-migration"
}
