# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-fakegem

DESCRIPTION="This is a simple wrapper over the kqueue BSD event notification interface"
HOMEPAGE="http://rubygems.org/gems/rb-kqueue"
SRC_URI="https://github.com/mat813/rb-kqueue/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""
