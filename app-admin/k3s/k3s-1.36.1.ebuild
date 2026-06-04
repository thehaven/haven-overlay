# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Lightweight Kubernetes"
HOMEPAGE="https://k3s.io/ https://github.com/k3s-io/k3s"
SUFFIX='%2Bk3s1'
MY_PV="${PV/_/-}"
SRC_URI="https://github.com/k3s-io/k3s/releases/download/v${MY_PV}${SUFFIX}/k3s -> ${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+server agent"
REQUIRED_USE="|| ( server agent )"

RDEPEND="
	net-firewall/iptables
"

S="${WORKDIR}"

QA_PREBUILT="usr/bin/k3s"

src_unpack() {
	cp "${DISTDIR}/${P}" "${WORKDIR}/k3s" || die
	chmod +x "${WORKDIR}/k3s" || die
}

src_install() {
	exeinto /usr/bin
	doexe k3s

	keepdir /etc/rancher/k3s
	keepdir /var/lib/rancher/k3s

	systemd_newunit "${FILESDIR}/k3s-server.service" k3s-server.service
	systemd_newunit "${FILESDIR}/k3s-agent.service" k3s-agent.service

	newinitd "${FILESDIR}/k3s-server.initd" k3s-server
	newinitd "${FILESDIR}/k3s-agent.initd" k3s-agent
	newconfd "${FILESDIR}/k3s-server.confd" k3s-server
	newconfd "${FILESDIR}/k3s-agent.confd" k3s-agent
}

pkg_postinst() {
	if use server; then
		elog "To start k3s server:"
		elog "  systemctl enable --now k3s-server"
		elog "or with OpenRC:"
		elog "  rc-update add k3s-server default && rc-service k3s-server start"
		elog ""
		elog "Config: /etc/rancher/k3s/config.yaml"
		elog "Kubeconfig: /etc/rancher/k3s/k3s.yaml (after first start)"
	fi
	if use agent; then
		elog "To start k3s agent:"
		elog "  systemctl enable --now k3s-agent"
		elog "or with OpenRC:"
		elog "  rc-update add k3s-agent default && rc-service k3s-agent start"
		elog ""
		elog "Set K3S_URL and K3S_TOKEN in the config before starting."
	fi
}
