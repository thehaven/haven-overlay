# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-fakegem

DESCRIPTION="Heavy metal SOAP client"
HOMEPAGE="http://rubygems.org/gems/savon"
SRC_URI="https://github.com/savonrb/savon/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend "
				  >=dev-ruby/rake-0.8.7
				  >=dev-ruby/rspec-2.5.0
				  >=dev-ruby/mocha-0.9.8
				  >=dev-ruby/timecop-0.3.5
				  "
