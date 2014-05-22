# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-fakegem

DESCRIPTION="NTLM Authentication Library for Ruby"
HOMEPAGE="https://rubygems.org/gems/rubyntlm"
SRC_URI="https://github.com/winrb/rubyntlm/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/rake
				  dev-ruby/rspec
				  dev-ruby/simplecov
				  "
