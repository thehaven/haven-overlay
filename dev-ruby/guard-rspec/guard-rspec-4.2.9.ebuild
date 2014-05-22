# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-fakegem

DESCRIPTION="Guard::RSpec allows to automatically & intelligently launch specs when files are modified."
HOMEPAGE="http://rubygems.org/gems/guard-rspec"
SRC_URI="https://github.com/guard/guard-rspec/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/bundler-1.3.5
				  >=dev-ruby/rake-10.1
				  >=dev-ruby/launchy-2.4
				  "
