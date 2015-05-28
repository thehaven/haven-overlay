# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-fakegem

DESCRIPTION="Add links to users and issues in your CHANGELOG.md."
HOMEPAGE="https://github.com/pcreux/pimpmychangelog"
SRC_URI="https://github.com/pcreux/pimpmychangelog/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/rspec
				  dev-ruby/guard-rspec
				  dev-ruby/rake
				  "
