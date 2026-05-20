# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit git-r3 go-module linux-info systemd tmpfiles

DESCRIPTION="Tailscale vpn client (live ebuild)"
HOMEPAGE="https://tailscale.com"
EGIT_REPO_URI="https://github.com/tailscale/tailscale.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="derper"

CONFIG_CHECK="~TUN"

RDEPEND="|| ( net-firewall/iptables net-firewall/nftables )"
BDEPEND=">=dev-lang/go-1.25.5"

# We must bypass network sandbox because we compile without vendor tarball (overlay pragmatic)
RESTRICT="network-sandbox"

src_compile() {
	# Determine version info dynamically
	local git_hash="${EGIT_VERSION:-unknown}"
	local version_short
	if [[ -f VERSION.txt ]]; then
		version_short=$(tr -d '\r\n' < VERSION.txt)
	else
		version_short="9999"
	fi
	local version_long="${version_short}-t${git_hash:0:9}"

	ego build -tags xversion -ldflags "
		-X tailscale.com/version.longStamp=${version_long}
		-X tailscale.com/version.shortStamp=${version_short}
		-X tailscale.com/version.gitCommitStamp=${git_hash}" ./cmd/tailscale

	ego build -tags xversion -ldflags "
		-X tailscale.com/version.longStamp=${version_long}
		-X tailscale.com/version.shortStamp=${version_short}
		-X tailscale.com/version.gitCommitStamp=${git_hash}" ./cmd/tailscaled

	if use derper; then
		ego build -tags xversion -ldflags "
			-X tailscale.com/version.longStamp=${version_long}
			-X tailscale.com/version.shortStamp=${version_short}
			-X tailscale.com/version.gitCommitStamp=${git_hash}" ./cmd/derper
	fi
}

src_test() {
	ego test -short ./...
}

src_install() {
	dosbin tailscaled
	dobin tailscale
	if use derper; then
		dobin derper
	fi

	systemd_dounit cmd/tailscaled/tailscaled.service
	insinto /etc/default
	newins cmd/tailscaled/tailscaled.defaults tailscaled
	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}

	newtmpfiles "${FILESDIR}/${PN}.tmpfiles" ${PN}.conf

	newinitd "${FILESDIR}/${PN}d.initd" ${PN}
	newconfd "${FILESDIR}/${PN}d.confd" ${PN}
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
