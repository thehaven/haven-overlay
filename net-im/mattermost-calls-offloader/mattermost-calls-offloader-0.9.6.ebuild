# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module-offline systemd tmpfiles

DESCRIPTION="External service to offload the routing of Mattermost Calls"
HOMEPAGE="https://github.com/mattermost/calls-offloader"
SRC_URI="https://github.com/mattermost/calls-offloader/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~haven/${PN}/${P}-vendor.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="recording"

# The service account runs the daemon
DEPEND="acct-user/mattermost acct-group/mattermost"
RDEPEND="${DEPEND}
	recording? ( media-video/ffmpeg )"
BDEPEND=">=dev-lang/go-1.22"

src_compile() {
	ego build -ldflags "-s -w -X main.version=${PV}" -o rtcd ./cmd/rtcd
}

src_install() {
	newbin rtcd mattermost-calls-offloader
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	dotmpfiles "${FILESDIR}"/${PN}.tmpfiles
}
