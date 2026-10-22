# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module linux-info systemd tmpfiles

# Upstream spells prereleases with a dash (v1.105.0-pre) where Portage uses an
# underscore (1.105.0_pre), and the git archive unpacks into a directory named
# after the tag, so derive the upstream spelling of the version once.
MY_TPV="${PV/_/-}"

# These settings are obtained by running ./build_dist.sh shellvars` in
# the upstream repo.
# They should be updated on every bump; metadata/bump-hooks/net-vpn/tailscale
# derives them from the upstream tag and rewrites the assignments below.
VERSION_MINOR="102"
VERSION_SHORT="1.102.3"
VERSION_LONG="1.102.3-t53a0d659a"
VERSION_GIT_HASH="53a0d659afa51835dd7a9283873cca44261454f8"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/archive/v${MY_TPV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_TPV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="derper"

CONFIG_CHECK="~TUN"

RDEPEND="|| ( net-firewall/iptables net-firewall/nftables )"
BDEPEND=">=dev-lang/go-1.25.5"

# We must bypass network sandbox because we compile without vendor tarball (overlay pragmatic)
RESTRICT="network-sandbox"

build_dist() {
	ego build -tags xversion -ldflags "
		-X tailscale.com/version.longStamp=${VERSION_LONG}
		-X tailscale.com/version.shortStamp=${VERSION_SHORT}
		-X tailscale.com/version.gitCommitStamp=${VERSION_GIT_HASH}" "$@"
}

src_compile() {
	build_dist ./cmd/tailscale
	build_dist ./cmd/tailscaled
	if use derper; then
		build_dist ./cmd/derper
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
