EAPI=7

DESCRIPTION="DevOps Pipeline Automation & Optimization"
HOMEPAGE="https://jfrog.com/pipelines/"
SRC_URI="https://bintray.com/jfrog/pipelines/download_file?file_path=installer%2Fpipelines-${PV}.tar.gz -> pipelines-${PV}.tar.gz"

inherit user

LICENSE=""
SLOT="0"
KEYWORDS="**"

DEPEND="dev-lang/python
		app-misc/jq
		app-misc/yq
		net-misc/curl
		net-analyzer/openbsd-netcat
		dev-db/postgresql
		app-emulation/docker-compose
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
	dodir ${PIPELINES_HOME}/installer || die
	cp -rf . ${PIPELINES_HOME}/installer || die
	chown -Rf pipelines:pipelines ${PIPELINES_HOME}/installer || die
}
