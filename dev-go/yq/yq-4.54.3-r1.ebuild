# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A lightweight and portable command-line YAML processor"
HOMEPAGE="https://github.com/mikefarah/yq"
SRC_URI="https://github.com/mikefarah/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox test strip"

BDEPEND=">=dev-lang/go-1.21"

# Revision bump only: rebuild so the recorded dev-lang/go subslot matches the
# current toolchain. The previous build recorded
# >=dev-lang/go-1.24.11:0/1.26.7= (the go-module.eclass-injected BDEPEND),
# which pins a second Go into slot 0 during a world update.

# app-misc/yq (python) also installs /usr/bin/yq
RDEPEND="!app-misc/yq"

S="${WORKDIR}/${PN}-${PV}"

src_compile() {
	# No vendor tarball: go fetches modules at build time (network-sandbox
	# opens network). The former 3.4.1 ebuild's EGO_SUM block does not apply
	# to the 4.x dependency graph.
	export -n GOCACHE XDG_CACHE_HOME
	go build -o "${PN}" . || die
}

src_install() {
	dobin ${PN}
	einstalldocs
}
