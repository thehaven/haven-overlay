# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-fakegem

DESCRIPTION="Windows Directory Monitor (WDM) is a threaded directories monitor for Windows."
HOMEPAGE="http://rubygems.org/gems/wdm"
SRC_URI="https://github.com/Maher4Ever/wdm/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/rake-compiler
				  dev-ruby/rspec
				  dev-ruby/guard-rspec
				  dev-ruby/guard-shell
				  dev-ruby/rb-readline
				  dev-ruby/rb-notifu
				  dev-ruby/pimpmychangelog
				  "
