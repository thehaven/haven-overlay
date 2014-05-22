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

ruby_add_rdepend ">=dev-ruby/akami-1.2.0
				  >=dev-ruby/builder-2.1.2
				  >=dev-ruby/gyoku-1.1.0
				  >=dev-ruby/httpi-0.9.0 <dev-ruby/httpi-1.0.0
				  >=dev-ruby/nokogiri-1.4.0
				  <dev-ruby/nokogiri-1.6
				  =dev-ruby/nori-1.0.0
				  >=dev-ruby/wasabi-1.0.0 <dev-ruby/wasabi-2.0.0
				  "
