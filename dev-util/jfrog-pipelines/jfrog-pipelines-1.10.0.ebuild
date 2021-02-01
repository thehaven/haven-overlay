EAPI=7

DESCRIPTION="DevOps Pipeline Automation & Optimization"
HOMEPAGE="https://jfrog.com/pipelines/"
SRC_URI="https://bintray.com/jfrog/pipelines/download_file?file_path=installer%2Fpipelines-${PV}.tar.gz -> pipelines-${PV}.tar.gz"

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

S="${WORKDIR}/${MY_PN}-${MY_PV}"

JFROG_HOME="/opt/jfrog"
PIPELINES_HOME="${JFROG_HOME}/pipelines"

pkg_setup() {
	enewgroup pipelines
	enewuser pipelines -1 /bin/sh -1 pipelines
}


src_install() {
	insinto ${PIPELINES_HOME}
	doins -r installer
}
