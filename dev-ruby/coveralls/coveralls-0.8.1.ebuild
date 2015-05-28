# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-fakegem

DESCRIPTION="help developers deliver code confidently by showing which parts of your code aren?t covered by your test suite"
HOMEPAGE="https://coveralls.io/"
#SRC_URI="https://github.com/lemurheavy/coveralls-ruby/archive/v${PV}.tar.gz -> ${P}-git.tgz"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/rspec
				  dev-ruby/truthy
				  dev-ruby/webmock
				  dev-ruby/rake
				  dev-ruby/vcr
				  "

each_ruby_prepare() {
	if [ -f Gemfile ]
	then
		BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle install --local || die
		BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle check || die
	fi
}
