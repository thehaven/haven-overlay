# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Chromium revision from Playwright's browser manifest
# Downloaded from Microsoft CDN via network-sandbox.
# Matches Chrome for Testing build.
PLAYWRIGHT_REV="1205"

DESCRIPTION="Chromium browser binary for Playwright (version-pinned, headless)"
HOMEPAGE="https://playwright.dev"

BASE_URI="https://playwright.azureedge.net/builds/chromium/${PLAYWRIGHT_REV}"
SRC_URI="
	amd64? ( ${BASE_URI}/chromium-linux.zip -> ${PN}-${PV}-amd64.zip )
	arm64? ( ${BASE_URI}/chromium-linux-arm64.zip -> ${PN}-${PV}-arm64.zip )
"

S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

RESTRICT="mirror strip network-sandbox"

BDEPEND="app-arch/unzip"

QA_PREBUILT="*"

src_install() {
	# The zip extracts to a directory named 'chrome-linux' or 'chrome-linux-arm64'
	local chrome_dir
	chrome_dir=$(find "${S}" -maxdepth 1 -type d -name 'chrome-*' | head -n 1)
	[[ -n "${chrome_dir}" ]] || die "Chromium directory not found in archive"

	local install_dir="/usr/share/playwright-browsers/chromium-${PLAYWRIGHT_REV}"
	insinto "${install_dir}"
	doins -r "${chrome_dir}"/*

	# Make chrome binary executable
	fperms 0755 "${install_dir}/chrome"
}

pkg_postinst() {
	einfo "Playwright Chromium ${PLAYWRIGHT_REV} installed."
	einfo "Path: /usr/share/playwright-browsers/chromium-${PLAYWRIGHT_REV}/"
	einfo ""
	einfo "Set PLAYWRIGHT_BROWSERS_PATH=/usr/share/playwright-browsers"
	einfo "for Playwright MCP to find this browser."
}
