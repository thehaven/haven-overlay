# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Angular portal for Project Harbor"
HOMEPAGE="https://github.com/goharbor/harbor"
SRC_URI="https://github.com/goharbor/harbor/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Node/Angular builds typically need network for npm install
RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs
	sys-apps/yarn"

S="${WORKDIR}/harbor-${PV}/src/portal"

src_compile() {
	yarn install || die
	yarn build --configuration production || die
}

src_install() {
	insinto /var/www/harbor-portal
	doins -r dist/*
}
