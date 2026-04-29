# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module-offline systemd tmpfiles

DESCRIPTION="Open source Slack-alternative in Golang and React"
HOMEPAGE="https://mattermost.com/"

WEBAPP_TARBALL="mattermost-${PV}-linux-amd64.tar.gz"

SRC_URI="
	https://github.com/mattermost/mattermost/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://releases.mattermost.com/${PV}/${WEBAPP_TARBALL}
	https://dev.gentoo.org/~haven/${PN}/${P}-vendor.tar.xz
"

LICENSE="Apache-2.0 MIT AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="postgres mysql redis calls"

DEPEND="acct-user/mattermost acct-group/mattermost"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.22"

RESTRICT="network-sandbox"

src_unpack() {
	go-module-offline_src_unpack
}

src_compile() {
	cd server || die
	ego build -ldflags "-s -w -X github.com/mattermost/mattermost/server/v8/model.BuildNumber=${PV}" -o mattermost ./cmd/mattermost
}

src_install() {
	# Install the server binary
	exeinto /opt/mattermost/bin
	doexe server/mattermost

	# Install the pre-built webapp
	insinto /opt/mattermost
	doins -r "${WORKDIR}/mattermost/client"
	doins -r "${WORKDIR}/mattermost/i18n"
	doins -r "${WORKDIR}/mattermost/templates"
	doins -r "${WORKDIR}/mattermost/fonts"

	# Install config
	insinto /etc/mattermost
	newins "${WORKDIR}/mattermost/config/config.json" config.json.sample

	# Set up permissions
	fowners -R mattermost:mattermost /opt/mattermost /etc/mattermost

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	dotmpfiles "${FILESDIR}"/${PN}.tmpfiles
}

pkg_postinst() {
	einfo "Mattermost is installed in /opt/mattermost"
	einfo "A sample config is provided at /etc/mattermost/config.json.sample"
}
