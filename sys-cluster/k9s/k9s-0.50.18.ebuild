# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Terminal based UI to manage Kubernetes clusters"
HOMEPAGE="https://k9scli.io/ https://github.com/derailed/k9s"
SRC_URI="https://github.com/derailed/k9s/releases/download/v${PV}/k9s_Linux_amd64.tar.gz -> ${P}-linux-amd64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"

QA_PREBUILT="usr/bin/k9s"

src_install() {
	dobin k9s
}
