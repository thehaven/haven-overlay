# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

XORG_DRI=always
XORG_EAUTORECONF=yes
XORG_MODULE=driver/
XORG_MODULE_REBUILD=yes

inherit autotools-utils xorg-2 toolchain-funcs

DESCRIPTION="OpenGL based 2D rendering acceleration library"
if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/xorg/driver/glamor"
else
	SRC_URI="mirror://gentoo/${P}.tar.gz"
fi

KEYWORDS=""
IUSE="gles xv"

RDEPEND=">=x11-base/xorg-server-1.10
	media-libs/mesa[egl,gbm]
	gles? (
		|| ( media-libs/mesa[gles2] media-libs/mesa[gles] )
	)
	>=x11-libs/pixman-0.21.8"
DEPEND="${RDEPEND}"

#PATCHES=(
#    "${FILESDIR}"/${P}-xv-add-missing-include.patch
#    "${FILESDIR}"/${P}-glamor_egl_create_argb8888.patch
#§)

src_prepare() {
    sed -i 's/inst_LTLIBRARIES/lib_LTLIBRARIES/' src/Makefile.am || die
    xorg-2_src_prepare
    # fail to load grafic driver with hardened compiler #488906
    if gcc-specs-now ; then
        append-ldflags -Wl,-z,lazy
    fi
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable gles glamor-gles2)
		$(use_enable xv)
	)
	xorg-2_src_configure
}

src_install() {
    # workaround parallel install failure, bug #488124.
    autotools-utils_src_install -j1
}
