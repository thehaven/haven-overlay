# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Open Source Identity and Access Management"
HOMEPAGE="https://www.keycloak.org/"
SRC_URI="https://github.com/keycloak/keycloak/releases/download/${PV}/keycloak-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"

DEPEND=">=virtual/jre-21"
RDEPEND="${DEPEND}"

S="${WORKDIR}/keycloak-${PV}"
QA_PREBUILT="*"

src_install() {
	insinto /opt/keycloak
	doins -r *

	fperms +x /opt/keycloak/bin/kc.sh
	fperms +x /opt/keycloak/bin/kcadm.sh
	fperms +x /opt/keycloak/bin/kcreg.sh

	dosym ../../opt/keycloak/bin/kc.sh /usr/bin/kc
	dosym ../../opt/keycloak/bin/kcadm.sh /usr/bin/kcadm
	dosym ../../opt/keycloak/bin/kcreg.sh /usr/bin/kcreg
}
