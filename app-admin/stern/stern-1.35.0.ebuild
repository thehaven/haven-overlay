# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Multi-pod and container log tailing for Kubernetes"
HOMEPAGE="https://github.com/stern/stern"
SRC_URI="https://github.com/stern/stern/releases/download/v${PV}/${PN}_${PV}_linux_amd64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"

QA_PREBUILT="usr/bin/stern"

src_install() {
	dobin stern
}
