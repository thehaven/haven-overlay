# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-fakegem

DESCRIPTION="Powerful alternative to the standard IRB shell for Ruby"
HOMEPAGE="https://github.com/pry/pry"
SRC_URI="https://github.com/pry/pry/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/coderay-1.1.0
				  >=dev-ruby/slop-3.4
				  >=dev-ruby/method_source-0.8.1
				  >=dev-ruby/bundler-1.0
				  "
