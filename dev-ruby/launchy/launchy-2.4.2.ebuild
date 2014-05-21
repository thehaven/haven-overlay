# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-fakegem

DESCRIPTION="A helper for launching cross-platform applications in a fire and forget manner."
HOMEPAGE="https://rubygems.org/gems/launchy"
SRC_URI="https://github.com/copiousfreetime/launchy/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rake-10.1
				  >=dev-ruby/minitest-5.0
				  >=dev-ruby/rdoc-4.1
				  >=dev-ruby/spoon-0.0.1
				  "
