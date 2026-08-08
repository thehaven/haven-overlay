# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd tmpfiles

DESCRIPTION="Modern, self-hosted music streaming server (Subsonic-compatible)"
HOMEPAGE="https://www.navidrome.org https://github.com/navidrome/navidrome"
SRC_URI="https://github.com/navidrome/navidrome/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 MIT BSD BSD-2 Apache-2.0 ISC MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Network is ALLOWED here (this value disables the default global
# FEATURES=network-sandbox namespace for this package): the Go build
# downloads modules and `npm ci` fetches the UI dependency tree.
RESTRICT="network-sandbox"

DEPEND="
	acct-group/navidrome
	acct-user/navidrome
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-lang/go-1.26
	>=net-libs/nodejs-24[npm]
"

src_compile() {
	# Build the embedded web UI (upstream: make buildjs). `npm ci` runs the
	# upstream postinstall (ui/bin/update-workbox.sh) which populates
	# public/3rdparty/workbox for the PWA service worker.
	cd ui || die
	npm ci || die "npm ci failed"
	npm run build || die "npm run build failed"
	cd .. || die

	# Build the Go server with the UI embedded (upstream: make build).
	ego build \
		-ldflags "-s -w -X github.com/navidrome/navidrome/consts.gitSha=source_archive -X github.com/navidrome/navidrome/consts.gitTag=v${PV}" \
		-tags "netgo sqlite_fts5" \
		-o navidrome . || die
}

src_install() {
	dobin navidrome

	insinto /etc/navidrome
	newins "${FILESDIR}"/navidrome.toml.example navidrome.toml.example
	fowners navidrome:navidrome /etc/navidrome

	keepdir /var/lib/navidrome
	fowners navidrome:navidrome /var/lib/navidrome

	newinitd "${FILESDIR}"/navidrome.initd navidrome
	newconfd "${FILESDIR}"/navidrome.confd navidrome
	systemd_dounit "${FILESDIR}"/navidrome.service
	dotmpfiles "${FILESDIR}"/navidrome.conf

	einstalldocs
}

pkg_postinst() {
	elog "Navidrome is installed. Configure /etc/navidrome/navidrome.toml"
	elog "(a documented example is installed as navidrome.toml.example),"
	elog "then start the service:"
	elog "  OpenRC:  rc-service navidrome start"
	elog "  systemd: systemctl enable --now navidrome"
	elog "On first run, create the admin user at http://<host>:4533"
}
