# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Cloud-native runtime security (Source build)"
HOMEPAGE="https://falco.org"
SRC_URI="https://github.com/falcosecurity/falco/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Falco build system downloads many dependencies even with bundled deps if not pre-fetched
# For a pragmatic overlay build, we allow network-sandbox or use bundled deps
RESTRICT="network-sandbox"

DEPEND="
	dev-libs/elfutils
	dev-libs/libyaml
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-util/cmake-3.20
	sys-devel/clang
"

src_configure() {
	local mycmakeargs=(
		-DUSE_BUNDLED_DEPS=ON
		-DBUILD_FALCO_UNIT_TESTS=OFF
		-DBUILD_DRIVER=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	insinto /etc/falco
	doins -r "${S}/falco.yaml" "${S}/rules"
}
