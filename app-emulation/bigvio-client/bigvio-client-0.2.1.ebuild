# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

USE_RUBY="ruby18"

DESCRIPTION="Virtual Machine manager for Bytemark's Service"
HOMEPAGE="http://www.bigv.io/"
SRC_URI="http://client.bigv.io/tgz/bigv-latest.tgz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="ruby_targets_ruby18"

DEPEND="dev-ruby/highline
		dev-ruby/json"
RDEPEND="${DEPEND}"

src_install() {
		cd ${WORKDIR}/bigv_0.1-2405
		ruby setup.rb || die "setup.rb failed"
		cd /usr/lib64/ruby/site_ruby/1.8/bigv/bmcloud
}

pkg_postinst() {
		echo
		einfo "Type \"bigv version\" to check that it has worked"
		einfo "Further instructions at: http://bigv.io/support/howto/"
		echo
}
