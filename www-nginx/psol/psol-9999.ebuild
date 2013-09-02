# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit subversion

DESCRIPTION="PageSpeed Optimization Libraries - used for ngx_pagespeed mod"
HOMEPAGE="https://github.com/pagespeed/ngx_pagespeed"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-util/depot_tools"
RDEPEND="${DEPEND}"

src_prepare() {
  cd ${WORKDIR}
  gclient config http://modpagespeed.googlecode.com/svn/trunk/src
  gclient sync --force --jobs=1
}

src_compile() {
  cd ${WORKDIR}/src
  make AR.host="$PWD/build/wrappers/ar.sh" \
    AR.target="$PWD/build/wrappers/ar.sh" \
    BUILDTYPE=Release \
    mod_pagespeed_test pagespeed_automatic_test

  cd ${WORKDIR}/src/net/instaweb/automatic
  make CXXFLAGS="-DSERF_HTTPS_FETCHING=0" \
    BUILDTYPE=Release \
    AR.host="$PWD/../../../build/wrappers/ar.sh" \
    AR.target="$PWD/../../../build/wrappers/ar.sh" \
    all
}

src_install() {
# Put the compiled psol files somewhere that nginx can be pointed at to compile mod_pagespeed
}
