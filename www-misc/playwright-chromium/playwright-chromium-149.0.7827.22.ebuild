# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Chrome for Testing — official Google distribution for automation.
# Source: https://googlechromelabs.github.io/chrome-for-testing/
# No auth required (public Google Storage bucket).
# Version: 149.0.7827.22 (Stable channel)

DESCRIPTION="Chromium browser for Playwright — Chrome for Testing (Google-hosted)"
HOMEPAGE="https://developer.chrome.com/blog/chrome-for-testing"

BASE_URI="https://storage.googleapis.com/chrome-for-testing-public/${PV}/linux64"
SRC_URI="
	amd64? ( ${BASE_URI}/chrome-linux64.zip -> ${PN}-${PV}-amd64.zip )
"

S="${WORKDIR}"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="mirror strip"

BDEPEND="app-arch/unzip"

QA_PREBUILT="*"

src_install() {
	# Chrome for Testing extracts to 'chrome-linux64/'
	local chrome_dir
	chrome_dir="${S}/chrome-linux64"
	[[ -d "${chrome_dir}" ]] || die "chrome-linux64 directory not found"

	insinto "/usr/share/playwright-browsers/chrome-${PV}"
	doins -r "${chrome_dir}"/*

	# Make chrome binary executable
	fperms 0755 "/usr/share/playwright-browsers/chrome-${PV}/chrome"
}

pkg_postinst() {
	einfo "Chrome for Testing ${PV} installed."
	einfo "Path: /usr/share/playwright-browsers/chrome-${PV}/"
	einfo ""
	einfo "Set PLAYWRIGHT_BROWSERS_PATH=/usr/share/playwright-browsers"
	einfo "for Playwright MCP to find this browser."
}
