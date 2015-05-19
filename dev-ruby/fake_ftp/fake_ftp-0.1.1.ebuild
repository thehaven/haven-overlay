# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-fakegem ${EGIT_REPO_URI:+git-2}

DESCRIPTION="A fake FTP server for use with RSpec"
HOMEPAGE="https://github.com/livinginthepast/fake_ftp"
GITHUB_URI="https://github.com/livinginthepast/fake_ftp"

if [[ ${PV} == "9999" ]]; then
    EGIT_REPO_URI="${GITHUB_URI}.git"
fi

if [[ -n ${EGIT_REPO_URI} ]]; then
    SRC_URI=""
else
	SRC_URI="${GITHUB_URI}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_rdepend "
				dev-ruby/bundler
				dev-ruby/rspec
				dev-ruby/guard-rspec
				dev-ruby/pry-nav
				"

if [[ ${PV} == "9999" ]]; then
    all_ruby_unpack() {
        git_src_unpack
    }
fi
