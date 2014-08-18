# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-fakegem

DESCRIPTION="Heavy metal SOAP client"
HOMEPAGE="https://github.com/phinze/landrush"
SRC_URI="https://github.com/phinze/landrush/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="${RDEPEND}
    app-emulation/vagrant"
