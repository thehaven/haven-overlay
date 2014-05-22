# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-fakegem

DESCRIPTION="Guard is a command line tool to easily handle events on file system modifications."
HOMEPAGE="http://rubygems.org/gems/guard"
SRC_URI="https://github.com/guard/guard/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/thor-0.18.1
				  >=dev-ruby/listen-2.7
				  >=dev-ruby/pry-0.9.12
				  >=dev-ruby/lumberjack-1.0
				  >=dev-ruby/formatador-0.2.4
				  "
