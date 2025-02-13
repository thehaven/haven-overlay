# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Rancher Kubernetes Engine 2"
HOMEPAGE="https://docs.rke2.io/"
SUFFIX='%2Brke2r1'
MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"
SRC_URI="https://github.com/rancher/rke2/releases/download/v${MY_PV}${SUFFIX}/rke2.linux-amd64.tar.gz -> rke2-v${MY_PV}.linux-amd64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="**"
IUSE="server agent"
REQUIRED_USE="|| ( server agent )"

DEPEND=""
RDEPEND="${DEPEND}
	>=app-containers/containerd-1.6.0
	>=app-containers/runc-1.1.0
	>=sys-fs/fuse-overlayfs-1.7
	>=app-containers/crun-1.0
"

PATCHES=( "${FILESDIR}/rke2-server-path.patch" )

src_unpack() {
	default
	mkdir "${WORKDIR}/${P}" || die
	mv "${WORKDIR}/bin" "${WORKDIR}/${P}/" || die
	mv "${WORKDIR}/lib" "${WORKDIR}/${P}/" || die
	mv "${WORKDIR}/share" "${WORKDIR}/${P}/" || die
}

src_install() {
	# Install the rke2 binary into /usr/bin
	dobin "${S}/bin/rke2" || die

	# Install the share files into /usr/share/rke2.
	insinto /usr/share/rke2 || die
	doins -r "${S}/share/rke2" || die

	# Install systemd unit files into /usr/lib/systemd/system
	insinto /usr/lib/systemd/system || die
	doins "${S}/lib/systemd/system/"* || die
}

pkg_postinst() {
	if use server; then
        elog "To enable rke2-server do:"
        elog "  systemctl enable rke2-server"
        elog "  systemctl start rke2-server"
    fi

	if use agent; then
        elog "To enable rke2-agent do:"
        elog "  systemctl enable rke2-agent"
        elog "  systemctl start rke2-agent"
    fi
}
