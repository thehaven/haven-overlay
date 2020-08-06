# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Using a binary ebuild until a source ebuild is doable.
# This was previously blocked by two major bugs upstream:
# A lack of documented build instructions - https://www.jfrog.com/jira/browse/RTFACT-8960
# A lack of source releases - https://www.jfrog.com/jira/browse/RTFACT-8961
# Upstream now releases source and instructions (yay!), but most of artifactory's
# dependencies are not in portage yet.

EAPI=6

inherit user systemd

MY_P="${P/-bin}"
MY_PN="${PN/-bin}"
MY_PV="${PV/-bin}"

DESCRIPTION="The world's most advanced repository manager for maven"
HOMEPAGE="http://www.jfrog.org/products.php"
SRC_URI="https://bintray.com/jfrog/artifactory-pro/download_file?file_path=org%2Fartifactory%2Fpro%2Fjfrog-artifactory-pro%2F${MY_PV}%2Fjfrog-artifactory-pro-${MY_PV}-linux.tar.gz&callback_id=anonymous -> ${MY_P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="**"
IUSE="ssl"

RDEPEND="virtual/jre"
DEPEND="virtual/jdk
		dev-java/openjdk-bin
		app-arch/unzip
		app-shells/bash"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

pkg_setup() {
	enewgroup artifactory
	enewuser artifactory -1 /bin/sh -1 artifactory
}

limitsdfile=40-${MY_PN}.conf

print_limitsdfile() {
	printf "# Start of ${limitsdfile} from ${P}\n\n"
	printf "@${MY_PN}\t-\tnofile\t32000\n"
	printf "\n# End of ${limitsdfile} from ${P}\n"
}

src_prepare() {
	default

	# Reverse https://www.jfrog.com/jira/browse/RTFACT-7123
	sed -i -e "s%artifactory.repo.global.disabled=true%artifactory.repo.global.disabled=false%g;" \
		app/misc/etc/artifactory/artifactory.system.properties || die

	einfo "Generating ${limitsdfile}"
	print_limitsdfile > "${S}/${limitsdfile}"
}

src_install() {
	local JFROG_HOME="/opt/jfrog"
	local ARTIFACTORY_HOME="${JFROG_HOME}/artifactory"
	local TOMCAT_HOME="${ARTIFACTORY_HOME}/tomcat"

	insinto ${ARTIFACTORY_HOME}
	doins -r app var

	dodir /etc/opt/jfrog
	dosym ${ARTIFACTORY_HOME}/var/etc /etc/opt/jfrog/artifactory

	dosym ${ARTIFACTORY_HOME}/var/logs /var/log/artifactory

	exeinto ${ARTIFACTORY_HOME}/app/bin
	doexe app/bin/*

	exeinto ${ARTIFACTORY_HOME}/app/third-party/java/bin/
	doexe app/third-party/java/bin/*

	# FIXME: this is called by catalina.sh (it echoes the variables before starting
	# artifactory, as well as makes sure log dir, etc. exists). Those directories
	# could probably be moved to the ebuild and the script removed from catalina.sh
	# without consequence (and quieter starts). Would need to check if CATALINA_*
	# variables are actually used anywhere (from reading code don't appear to be
	# actually needed)
	exeinto ${TOMCAT_HOME}/bin
	doexe app/misc/service/setenv.sh
	doexe app/artifactory/tomcat/bin/*

	keepdir ${ARTIFACTORY_HOME}/var/backup
	keepdir ${ARTIFACTORY_HOME}/var/data
	keepdir ${ARTIFACTORY_HOME}/var/log
	keepdir ${ARTIFACTORY_HOME}/var/run
	keepdir ${ARTIFACTORY_HOME}/var/work
	keepdir ${TOMCAT_HOME}/logs/catalina
	keepdir ${TOMCAT_HOME}/temp
	keepdir ${TOMCAT_HOME}/work
	keepdir /var/opt/jfrog/artifactory/run

	# Optional
	keepdir ${ARTIFACTORY_HOME}/var/backup/artifactory
	keepdir ${ARTIFACTORY_HOME}/var/backup/access
	keepdir ${ARTIFACTORY_HOME}/var/backup/replicator
	keepdir ${ARTIFACTORY_HOME}/var/log/archived/access
	keepdir ${ARTIFACTORY_HOME}/var/log/archived/replicator

	insinto ${ARTIFACTORY_HOME}/etc/
	doins ${FILESDIR}/"default"

	insinto ${ARTIFACTORY_HOME}/misc/service/
	doins ${FILESDIR}/artifactory.service

	newconfd "${FILESDIR}/confd" ${MY_PN}
	newinitd "${FILESDIR}/initd-r3" ${MY_PN}

	systemd_dounit "${FILESDIR}/artifactory.service"
	systemd_newunit "${FILESDIR}/artifactory.service" "${PN}@.service"

	fowners -R artifactory:artifactory ${ARTIFACTORY_HOME}
	fperms -R u+w ${TOMCAT_HOME}/work

	insinto /etc/security/limits.d
	doins "${S}/${limitsdfile}"
}
