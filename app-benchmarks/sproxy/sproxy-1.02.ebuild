## net-proxy/sproxy/sproxy-1.01.ebuild

# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils bash-completion

DESCRIPTION="Sproxy replaces Scout as the preferred method of URL harvest for
Siege. It is an HTTP proxy server written in perl and designed to collect all
URL information in a siege-friendly format. All necessary modules are bundled
with the source. Sproxy is built with GNU autotools."
HOMEPAGE="http://www.joedog.org/JoeDog/Sproxy"
SRC_URI="ftp://sid.joedog.org/pub/sproxy/sproxy-latest.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~hppa ~mips ppc x86"
SLOT="0"

DEPEND="dev-perl/HTML-Parser
        dev-perl/URI"

src_install() {
    emake prefix="${D}/usr" DESTDIR="${D}" install || die "make install failed"

}
