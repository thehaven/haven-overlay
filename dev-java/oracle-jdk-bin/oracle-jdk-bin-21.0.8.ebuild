# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-vm-2

DESCRIPTION="Oracle's Java SE Development Kit"
HOMEPAGE="https://www.oracle.com/java/"
SRC_URI="amd64? ( https://download.oracle.com/java/21/archive/jdk-${PV}_linux-x64_bin.tar.gz )
	arm64? ( https://download.oracle.com/java/21/archive/jdk-${PV}_linux-aarch64_bin.tar.gz )"

S="${WORKDIR}/jdk-${PV}"

LICENSE="NFTC"
SLOT="21"
KEYWORDS="-* ~amd64 ~arm64"

IUSE="alsa +commercial cups headless-awt +source"
RESTRICT="bindist mirror preserve-libs strip"
QA_PREBUILT="*"

RDEPEND="(
	alsa? ( media-libs/alsa-lib )
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/harfbuzz
	!headless-awt? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXtst
	)
	cups? ( net-print/cups )
)"

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}/${dest#/}"

	rm LICENSE README release || die

	# Create files used as storage for system preferences.
	mkdir .systemPrefs || die
	touch .systemPrefs/.system.lock || die
	touch .systemPrefs/.systemRootModFile || die

	# Drop alsa backend if not requested.
	if ! use alsa ; then
		rm -v lib/libjsound.so || die
	fi

	# Strip commercial-only JFR bits when not requested.
	if ! use commercial ; then
		rm -vfr bin/jfr jmods/*.jfr.* lib/jfr* legal/*.jfr || die
	fi

	# Headless: drop AWT/splashscreen libraries.
	if use headless-awt ; then
		rm -vf lib/lib*{[jx]awt,splashscreen}* || die
	fi

	if ! use source ; then
		rm -v lib/src.zip || die
	fi

	# Point cacerts at the system Java keystore.
	rm -v lib/security/cacerts || die
	dosym -r /etc/ssl/certs/java/cacerts "${dest}"/lib/security/cacerts

	dodir "${dest}"
	cp -pPR * "${ddest}" || die

	java-vm_install-env "${FILESDIR}"/"${PN}"-"${SLOT}".env.sh
	java-vm_set-pax-markings "${ddest}"
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
}

pkg_postinst() {
	elog "Oracle JDK ${PV} has been installed into /opt/${P}."
	elog "This build is subject to the Oracle No-Fee Terms and Conditions (NFTC)."
	elog "Acceptance of the license must be recorded in /etc/portage/package.license"
	elog "(e.g. =dev-java/oracle-jdk-bin-${PV} NFTC) before use."
}
