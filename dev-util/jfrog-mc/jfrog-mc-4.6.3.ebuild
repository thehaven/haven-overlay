EAPI=7

DESCRIPTION="DevOps Management at Scale"
HOMEPAGE="https://jfrog.com/mission-control/"
SRC_URI="https://bintray.com/jfrog/jfrog-mc/download_file?file_path=linux/${PV}/jfrog-mc-${PV}-linux.tar.gz -> jfrog-mc-${PV}.tar.gz"

inherit user systemd

LICENSE=""
SLOT="0"
KEYWORDS="**"

RDEPEND="virtual/jre"
DEPEND="virtual/jdk
		dev-java/openjdk-bin
		app-arch/unzip
		app-shells/bash
		app-misc/elasticsearch
		dev-db/postgresql:12
		"

S="${WORKDIR}/${PN}-${PV}-linux"

JFROG_HOME="/opt/jfrog"
MC_HOME="${JFROG_HOME}/mc"

pkg_setup() {
		enewgroup artifactory
		enewuser artifactory -1 /bin/sh -1 artifactory
}

src_install() {
	mkdir -p ${MC_HOME} || die
	cp -rf . ${MC_HOME} || die
	chown -Rf artifactory:artifactory ${MC_HOME} || die

	insinto /etc/sysctl.d/
	doins "${FILESDIR}/elasticsearch.conf"

	keepdir ${MC_HOME}/var/etc

	systemd_dounit "${FILESDIR}/jfrog-mc.service" || die
	systemd_newunit "${FILESDIR}/jfrog-mc.service" "${PN}@.service" || die
}

pkg_postinst() {
	einfo "Follow setup instructions at the link below:"
	einfo "https://www.jfrog.com/confluence/display/JFROG/Installing+Mission+Control#InstallingMissionControl-LinuxArchiveInstallation"
}
