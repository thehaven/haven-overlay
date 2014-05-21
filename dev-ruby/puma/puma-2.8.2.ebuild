# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="Puma is a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications"
HOMEPAGE="https://github.com/puma/puma"
SRC_URI="https://github.com/puma/puma/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-1.1
				  >=dev-ruby/rdoc-4.0
				  >=dev-ruby/rake-compiler-0.8.0
				  >=dev-ruby/hoe-3.6
				  "
