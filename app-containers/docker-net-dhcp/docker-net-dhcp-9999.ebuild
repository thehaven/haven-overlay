# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd git-r3

DESCRIPTION="Docker host bridge DHCP network plugin daemon"
HOMEPAGE="https://github.com/thehaven/docker-net-dhcp"
EGIT_REPO_URI="https://github.com/thehaven/docker-net-dhcp.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

RDEPEND="
	sys-apps/util-linux
	sys-apps/busybox
"
BDEPEND=">=dev-lang/go-1.22"

PROPERTIES="live"

src_unpack() {
	git-r3_src_unpack
	cd "${S}" || die
	ego mod download
}

src_compile() {
	ego build -ldflags "-s -w -X main.version=9999" -o bin/docker-net-dhcp ./cmd/net-dhcp || die
	ego build -ldflags "-s -w" -o bin/udhcpc-handler ./cmd/udhcpc-handler || die
	ego build -ldflags "-s -w" -o bin/docker-net-dhcp-macgen ./cmd/docker-net-dhcp-macgen || die
}

src_install() {
	dobin bin/docker-net-dhcp
	dobin bin/docker-net-dhcp-macgen

	exeinto /usr/libexec/docker-net-dhcp
	doexe bin/udhcpc-handler

	# Docker plugin spec discovery
	insinto /etc/docker/plugins
	doins "${FILESDIR}/net-dhcp.spec"

	# State directory
	keepdir /var/lib/docker-net-dhcp
	fperms 0700 /var/lib/docker-net-dhcp

	# Systemd unit
	systemd_dounit "${FILESDIR}/docker-net-dhcp.service"

	einstalldocs
}
