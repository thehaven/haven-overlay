# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Using a binary ebuild until a source ebuild is doable.
# This was previously blocked by two major bugs upstream:
# A lack of documented build instructions - https://www.jfrog.com/jira/browse/RTFACT-8960
# A lack of source releases - https://www.jfrog.com/jira/browse/RTFACT-8961
# Upstream now releases source and instructions (yay!), but most of artifactory's
# dependencies are not in portage yet.

EAPI=7

inherit user systemd

MY_P="${P/-bin}"
MY_PN="${PN/-bin}"
MY_PV="${PV/-bin}"

DESCRIPTION="The world's most advanced repository manager for maven"
HOMEPAGE="http://www.jfrog.org/products.php"
SRC_URI="https://releases.jfrog.io/artifactory/artifactory-pro/org/artifactory/pro/jfrog-artifactory-pro/${MY_PV}/jfrog-artifactory-pro-${MY_PV}-linux.tar.gz -> ${MY_P}.tar.gz"

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

JFROG_HOME="/opt/jfrog"
ARTIFACTORY_HOME="${JFROG_HOME}/artifactory"
TOMCAT_HOME="${ARTIFACTORY_HOME}/tomcat"

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
	insinto ${ARTIFACTORY_HOME}
	doins -r app var

	dodir /etc/opt/jfrog
	dosym ${ARTIFACTORY_HOME}/var/etc /etc/opt/jfrog/artifactory

	dosym ${ARTIFACTORY_HOME}/var/log /var/log/artifactory

	exeinto ${ARTIFACTORY_HOME}/app/bin
	doexe app/bin/*

	exeinto ${ARTIFACTORY_HOME}/app/event/bin
	doexe app/event/bin/*

	exeinto ${ARTIFACTORY_HOME}/app/router/bin/
	doexe app/router/bin/*

	exeinto ${ARTIFACTORY_HOME}/app/replicator/bin/
	doexe app/replicator/bin/*

	exeinto ${ARTIFACTORY_HOME}/app/metadata/bin/
	doexe app/metadata/bin/*

	exeinto ${ARTIFACTORY_HOME}/app/third-party/java/bin/
	doexe app/third-party/java/bin/*

	exeinto ${ARTIFACTORY_HOME}/app/artifactory/tomcat/bin/
	doexe app/artifactory/tomcat/bin/*

	exeinto ${ARTIFACTORY_HOME}/app/third-party/node/bin
	doexe app/third-party/node/bin/*

	exeinto ${ARTIFACTORY_HOME}/app/third-party/java/bin
	doexe app/third-party/java/bin/*

	exeinto ${ARTIFACTORY_HOME}/app/third-party/libxml2/bin
	doexe app/third-party/libxml2/bin/*

	exeinto ${ARTIFACTORY_HOME}/app/frontend/bin
	doexe app/frontend/bin/frontend.sh

	#exeinto ${ARTIFACTORY_HOME}/app/frontend/bin/server/dist/node_modules/*/bin/
	#doexe app/frontend/bin/server/dist/node_modules/*/bin/*

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
	keepdir ${ARTIFACTORY_HOME}/var/etc
	keepdir ${ARTIFACTORY_HOME}/var/log
	keepdir ${ARTIFACTORY_HOME}/var/log/tomcat
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

	newconfd "${FILESDIR}/confd" ${MY_PN}
	newinitd "${FILESDIR}/initd-r3" ${MY_PN}

	fowners -R artifactory:artifactory ${ARTIFACTORY_HOME}
	fperms -R u+w ${TOMCAT_HOME}/work

	insinto /etc/security/limits.d
	doins "${S}/${limitsdfile}"
}

pkg_postinst() {
	# Systemd Init:
	systemd_dounit "${ARTIFACTORY_HOME}/app/misc/service/artifactory.service"
	systemd_newunit "${ARTIFACTORY_HOME}/app/misc/service/artifactory.service" "${PN}@.service"

	# Injector:
	/bin/echo -e "2\n${ARTIFACTORY_HOME}/app/artifactory/tomcat\nyes\nexit\n" | java -jar ${FILESDIR}/artifactory.jar
}
