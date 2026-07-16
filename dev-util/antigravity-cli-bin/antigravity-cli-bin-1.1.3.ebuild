# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Google Antigravity CLI - Unified agentic terminal platform"
HOMEPAGE="https://antigravity.google"

# Manifest URL: https://antigravity-cli-auto-updater-974169037036.us-central1.run.app/manifests/linux_${ARCH}.json
# Version 1.1.3 ID: 5288553236791296
BASE_URI="https://storage.googleapis.com/antigravity-public/antigravity-cli/1.1.3-5723946948100096"
SRC_URI="
	amd64? ( ${BASE_URI}/linux-x64/cli_linux_x64.tar.gz -> ${PN}-${PV}-amd64.tar.gz )
	arm64? ( ${BASE_URI}/linux-arm/cli_linux_arm64.tar.gz -> ${PN}-${PV}-arm64.tar.gz )
"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
IUSE=""

RDEPEND=""

S="${WORKDIR}"

QA_PREBUILT="usr/bin/agy"

src_install() {
	newbin antigravity agy
}

pkg_postinst() {
	elog "Google Antigravity CLI (agy) has been installed."
	elog ""
	elog "IMPORTANT: Authentication Persistence"
	elog "If you are running in a headless environment or without a system keyring,"
	elog "you MUST use the following command for your first run/login to ensure"
	elog "the OAuth token is persisted to disk:"
	elog ""
	elog "  FORCE_FILE_STORAGE=true agy"
	elog ""
	elog "This forces agy to write to ~/.gemini/antigravity-cli/antigravity-oauth-token"
	elog ""
	elog "To migrate your existing Gemini extensions to Antigravity plugins, run:"
	elog "  agy plugin import gemini"
	elog ""
	elog "Please refer to the migration guide for more details:"
	elog "https://antigravity.google/docs/gcli-migration"
}
