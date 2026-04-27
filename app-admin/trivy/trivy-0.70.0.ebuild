# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Comprehensive and Versatile Security Scanner"
HOMEPAGE="https://github.com/aquasecurity/trivy"

BASE_URI="https://github.com/aquasecurity/trivy/releases/download/v${PV}"
SRC_URI="
	amd64? ( ${BASE_URI}/trivy_${PV}_Linux-64bit.tar.gz )
	arm64? ( ${BASE_URI}/trivy_${PV}_Linux-ARM64.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

QA_PREBUILT="usr/bin/trivy"
S="${WORKDIR}"

src_install() {
	dobin trivy
}
