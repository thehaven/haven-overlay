# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Splunk Universal Forwarder - lightweight remote data collector"
HOMEPAGE="https://www.splunk.com"

# MY_BUILD is a per-release SHA hash — must be updated on every version bump.
# Retrieve via: curl -sSlL https://www.splunk.com/en_us/download/universal-forwarder.html \
#   | grep -oP '(?<=data-link=")[^"]*linux-amd64\.tgz(?=")'
MY_BUILD="80b90d638de6"

BASE_URI="https://download.splunk.com/products/universalforwarder/releases/${PV}/linux"
SRC_URI="
	amd64? ( ${BASE_URI}/${PN}-${PV}-${MY_BUILD}-linux-amd64.tgz )
	arm64? ( ${BASE_URI}/${PN}-${PV}-${MY_BUILD}-linux-arm64.tgz )
"
S="${WORKDIR}/${PN}-${PV}-${MY_BUILD}"

LICENSE="splunk-eula"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
IUSE="systemd"

RESTRICT="bindist mirror"

RDEPEND="
	acct-group/splunkfwd
	acct-user/splunkfwd
"

QA_PREBUILT="opt/${PN}/.*"

src_install() {
	insinto "/opt/${PN}"
	doins -r "${S}"/. || die "doins failed"

	local b
	for b in "${S}"/bin/*; do
		[[ -f "${b}" ]] && fperms 0755 "/opt/${PN}/bin/${b##*/}"
	done

	keepdir "/opt/${PN}/var/log/splunk"
	keepdir "/opt/${PN}/var/run"
	fowners -R splunkfwd:splunkfwd "/opt/${PN}"

	if use systemd; then
		systemd_dounit "${FILESDIR}/${PN}.service"
	else
		doinitd "${FILESDIR}/splunkd"
	fi

	dodoc "${FILESDIR}/README.gentoo"
}

pkg_nofetch() {
	elog "Download the tarball manually from:"
	elog "  https://www.splunk.com/en_us/download/universal-forwarder.html"
	elog "Place it in: ${DISTDIR}"
}

pkg_postinst() {
	elog "Accept the EULA before first start:"
	elog "  /opt/${PN}/bin/splunk start --accept-license --answer-yes --no-prompt"
	elog "  /opt/${PN}/bin/splunk stop"
	elog "Docs: https://docs.splunk.com/Documentation/Forwarder"
}
