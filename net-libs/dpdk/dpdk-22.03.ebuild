# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic linux-info linux-mod meson

DESCRIPTION="A set of libraries and drivers for fast packet processing"
HOMEPAGE="http://dpdk.org/"
SRC_URI="https://fast.${PN}.org/rel/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl static-libs"

DEPEND="
	sys-process/numactl
	ssl? ( dev-libs/openssl:* )
"
RDEPEND="${DEPEND}"
DEPEND="
	${DEPEND}
	!net-libs/dpdk:stable
	dev-lang/nasm
	dev-util/meson
	dev-util/ninja
"

function ctarget() {
	CTARGET="${ARCH}"
	use amd64 && CTARGET='x86_64'
	echo $CTARGET
}

CONFIG_CHECK="~IOMMU_SUPPORT ~AMD_IOMMU ~VFIO ~VFIO_PCI"
if [ "$SLOT" != "0" ] ; then
	S=${WORKDIR}/${PN}-${SLOT#0/}-${PV}
fi

pkg_setup() {
	linux-mod_pkg_setup
}

src_configure() {
	meson_src_configure
}

src_compile() {
	meson build
	ninja -C build
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	einfo "Installer based off: https://core.dpdk.org/doc/quick-start/"
	einfo ""
	einfo "Remember to configure huge pages memory:"
	einfo "		mkdir -p /dev/hugepages"
	einfo "		mountpoint -q /dev/hugepages || mount -t hugetlbfs nodev /dev/hugepages"
	einfo "		echo 64 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages"
}
