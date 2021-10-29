EAPI=7

DESCRIPTION="DevOps Pipeline Automation & Optimization"
HOMEPAGE="https://jfrog.com/pipelines/"
# https://releases.jfrog.io/artifactory/pipelines/installer/pipelines-1.19.3.tar.gz
SRC_URI="https://releases.jfrog.io/artifactory/pipelines/installer/pipelines-${PV}.tar.gz -> pipelines-${PV}.tar.gz"

inherit user

LICENSE=""
SLOT="0"
KEYWORDS="**"

DEPEND="dev-lang/python
		app-misc/jq
		app-misc/yq
		net-misc/curl
		dev-python/virtualenv
		net-analyzer/openbsd-netcat
		dev-db/postgresql
		app-emulation/docker-compose
		dev-util/jfrog-cli
		"

S="${WORKDIR}/${PN#*-}-${PV}"

JFROG_HOME="/opt/jfrog"
PIPELINES_HOME="${JFROG_HOME}/pipelines"

pkg_setup() {
	enewgroup pipelines
	enewuser pipelines -1 /bin/sh ${PIPELINES_HOME} pipelines
	gpasswd -a pipelines docker
}

src_install() {
	mkdir -p ${PIPELINES_HOME}/installer || die
	dodir ${PIPELINES_HOME}/installer || die
	cp -rf . ${PIPELINES_HOME}/installer || die
	dodir  ${PIPELINES_HOME}/installer/scripts/x86_64/Gentoo_ || die
	cp -rf ${FILESDIR}/Gentoo_/ ${PIPELINES_HOME}/installer/scripts/x86_64/Gentoo_ || die
	dodir  ${PIPELINES_HOME}/installer/scripts/x86_64/Gentoo_2.8 || die
	cp -rf ${FILESDIR}/Gentoo_/ ${PIPELINES_HOME}/installer/scripts/x86_64/Gentoo_2.8 || die
	chown -Rf pipelines:pipelines ${PIPELINES_HOME}/installer || die
}
