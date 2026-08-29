# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd tmpfiles

DESCRIPTION="Open source Slack-alternative in Golang and React"
HOMEPAGE="https://mattermost.com/"

WEBAPP_TARBALL="mattermost-${PV}-linux-amd64.tar.gz"

SRC_URI="
	https://github.com/mattermost/mattermost/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://releases.mattermost.com/${PV}/${WEBAPP_TARBALL}
"

# GitHub archive of the "mattermost" repo unpacks to mattermost-${PV}.
S="${WORKDIR}/mattermost-${PV}"

LICENSE="Apache-2.0 MIT AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="postgres mysql redis calls"

DEPEND="acct-user/mattermost acct-group/mattermost"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.22"

RESTRICT="network-sandbox"

src_prepare() {
	default
	# Upstream bug: server/go.mod pins the published server/public module
	# (v0.1.22-0.20251105210629) whose model/user.go imports
	# channels/app/password/hashers, creating an import cycle with the
	# v11.6.1 channels code ("import cycle not allowed"). The tarball's own
	# ./public is self-consistent (no hashers reference); replace the
	# published module with it.
	printf '\nreplace github.com/mattermost/mattermost/server/public => ./public\n' >> server/go.mod || die
}

src_unpack() {
	default
	# The Go module lives in server/ (not the repo root); go-module's
	# default verify would run in ${S} where no go.mod exists.
	cd "${S}/server" || die
	ego mod verify
	go-env_set_compile_environment
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
	dotmpfiles "${FILESDIR}"/${PN}.tmpfiles.conf
}

pkg_postinst() {
	einfo "Mattermost is installed in /opt/mattermost"
	einfo "A sample config is provided at /etc/mattermost/config.json.sample"
}
