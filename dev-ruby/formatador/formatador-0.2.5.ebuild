# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-fakegem

DESCRIPTION="STDOUT text formatting"
HOMEPAGE="https://github.com/geemus/formatador"
SRC_URI="https://github.com/geemus/formatador/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""
