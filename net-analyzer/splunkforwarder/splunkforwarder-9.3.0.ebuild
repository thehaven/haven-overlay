# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Splunk Universal Forwarder - lightweight remote data collector"
HOMEPAGE="https://www.splunk.com"

# MY_BUILD is a per-release SHA hash — must be updated on every version bump.
# Retrieve via: curl -sSlL https://www.splunk.com/en_us/download/universal-forwarder.html \
#   | grep -oP '(?<=data-link=")[^"]*Linux-x86_64\.tgz(?=")'
MY_BUILD="51ccf43db5bd"

BASE_URI="https://download.splunk.com/products/universalforwarder/releases/${PV}/linux"
SRC_URI="
    amd64? ( ${BASE_URI}/${PN}-${PV}-${MY_BUILD}-Linux-x86_64.tgz )
    arm64? ( ${BASE_URI}/${PN}-${PV}-${MY_BUILD}-Linux-armv8.tgz )
"
S="${WORKDIR}/${PN}-${PV}-${MY_BUILD}"

LICENSE="splunk-eula"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
IUSE="systemd"

RESTRICT="bindist mirror"

BDEPEND=""
RDEPEND="
    acct-group/splunkfwd
    acct-user/splunkfwd
"

# Suppress QA warnings for the shipped bundled binaries/libs
QA_PREBUILT="opt/${PN}/.*"

src_install() {
	insinto "/opt/${PN}"
	doins -r "${S}"/. || die "doins failed"

	# Restore execute bits stripped by doins
	local b
	for b in "${S}"/bin/*; do
		[[ -f "${b}" ]] && fperms 0755 "/opt/${PN}/bin/${b##*/}"
	done
	for b in "${S}"/lib/*.so*; do
		[[ -f "${b}" ]] && fperms 0755 "/opt/${PN}/lib/${b##*/}"
	done

	# Runtime directories
	keepdir "/opt/${PN}/var/log/splunk"
	keepdir "/opt/${PN}/var/run"

	fowners -R splunk:splunk "/opt/${PN}"

	if use systemd; then
		systemd_dounit "${FILESDIR}/${PN}.service"
	else
		doinitd "${FILESDIR}/splunkd"
	fi

	dodoc "${FILESDIR}/README.gentoo"
}

pkg_nofetch() {
	elog "If SRC_URI fetch fails, download the tarball manually from:"
	elog "  https://www.splunk.com/en_us/download/universal-forwarder.html"
	elog "Place it in: ${DISTDIR}"
}

pkg_postinst() {
	elog "Accept the Splunk EULA before first start:"
	elog "  /opt/${PN}/bin/splunk start --accept-license --answer-yes --no-prompt"
	elog "  /opt/${PN}/bin/splunk stop"
	elog ""
	elog "Then enable and start the service via your init system."
	elog "Configure your deployment server in:"
	elog "  /opt/${PN}/etc/system/local/deploymentclient.conf"
	elog ""
	elog "Docs: https://docs.splunk.com/Documentation/Forwarder"
}
