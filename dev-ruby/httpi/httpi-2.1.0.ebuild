# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="A common interface for Ruby's HTTP libraries."
HOMEPAGE="http://rubygems.org/gems/httpi"
SRC_URI="https://github.com/savonrb/httpi/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rubyntlm-0.3.2
				  >=dev-ruby/rake-10.0
				  >=dev-ruby/rspec-2.12
				  >=dev-ruby/mocha-0.13
				  >=dev-ruby/puma-2.3.2
				  "
