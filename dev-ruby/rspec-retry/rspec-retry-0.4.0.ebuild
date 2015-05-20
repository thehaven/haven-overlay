# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-fakegem ${EGIT_REPO_URI:+git-2}

DESCRIPTION="adds a :retry option for intermittently failing rspec examples."
HOMEPAGE="https://github.com/y310/rspec-retry"
GITHUB_URI="https://github.com/y310/${PN}"

if [[ ${PV} == "9999" ]]; then
    EGIT_REPO_URI="${GITHUB_URI}.git"
fi

if [[ -n ${EGIT_REPO_URI} ]]; then
    SRC_URI=""
else
	SRC_URI="${GITHUB_URI}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

if [[ ${PV} == "9999" ]]; then
    all_ruby_unpack() {
        git_src_unpack
    }
fi
