# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vagrant/vagrant-1.4.3-r2.ebuild,v 1.2 2014/04/02 16:20:56 vikraman Exp $

EAPI="5"
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="vagrant.gemspec"
RUBY_FAKEGEM_EXTRAINSTALL="keys plugins templates version.txt"
RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem ruby-ng

DESCRIPTION="A tool for building and distributing virtual machines using VirtualBox"
HOMEPAGE="http://vagrantup.com/"
SRC_URI="https://github.com/mitchellh/vagrant/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="test"

# Missing ebuild for contest
RESTRICT="test"

RDEPEND="${RDEPEND}
	app-arch/libarchive
	net-misc/curl
	!x64-macos? ( || ( app-emulation/virtualbox app-emulation/virtualbox-bin ) )"

ruby_add_rdepend "
    >=dev-ruby/bundler-1.5.2 <dev-ruby/bundler-1.8.0
	>=dev-ruby/childprocess-0.5.0 <dev-ruby/childprocess-0.5.1
	>=dev-ruby/erubis-2.7.0 <dev-ruby/erubis-2.7.1
	>dev-ruby/hashicorp-checkpoint-0.1.1 <dev-ruby/hashicorp-checkpoint-0.1.2
    >=dev-ruby/i18n-0.6.0:0.6
	>=dev-ruby/listen-2.8.0 <dev-ruby/listen-2.8.1
	>=dev-ruby/log4r-1.1.9 <dev-ruby/log4r-1.1.11
	>=dev-ruby/net-ssh-2.6.6 <dev-ruby/net-ssh-2.10.0
	>=dev-ruby/net-sftp-2.1 <dev-ruby/net-sftp-2.2
	>=dev-ruby/net-scp-1.1.0 <dev-ruby/net-scp-1.2
	=dev-ruby/nokogiri-1.6.3.1
	>=dev-ruby/rest-client-1.6.0 <dev-ruby/rest-client-2.0
	>=dev-ruby/rubygems-1.3.6
	>=dev-ruby/rb-kqueue-0.2.0 <dev-ruby/rb-kqueue-0.2.1
	>=dev-ruby/wdm-0.1.0 <dev-ruby/wdm-0.1.1
	>=dev-ruby/winrm-1.3 <dev-ruby/winrm-1.4
	>=dev-ruby/winrm-fs-0.1.0 <dev-ruby/winrm-fs-0.1.1
"

ruby_add_bdepend "
	dev-ruby/rake
	>=dev-ruby/rspec-2.14.0 <dev-ruby/rspec-2.14.1
	>=dev-ruby/webmock-1.20 <dev-ruby/webmock-1.21
	>=dev-ruby/fake_ftp-0.1 <dev-ruby/fake_ftp-0.2
	test? ( dev-ruby/mocha virtual/ruby-minitest )
"

all_ruby_prepare() {
	# remove bundler support
	sed -i '/[Bb]undler/d' Rakefile || die
	rm Gemfile || die

	# loosen dependencies
	sed -e '/childprocess\|erubis\|log4r\|net-scp/s/~>/>=/' \
		-e '/net-ssh/s:, "< 2.8.0"::' \
		-i ${PN}.gemspec || die

	epatch "${FILESDIR}"/${PN}-1.6.2-no-warning.patch
	epatch "${FILESDIR}"/${PN}-1.6.2-rvm.patch
}

pkg_postinst() {
	if use x64-macos ; then
		ewarn
		ewarn "For Mac OS X prefixes, you must install the virtualbox"
		ewarn "package specifically for OS X which can be found at:"
		ewarn "https://www.virtualbox.org/wiki/Downloads"
		ewarn
	fi
}
