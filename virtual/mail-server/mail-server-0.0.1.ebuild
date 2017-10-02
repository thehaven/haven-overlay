# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual ebuild for a mail server based on Dovecot/Exim with SpamAssassin"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+exim +dovecot +spamassassin"

RDEPEND="
	exim? ( mail-mta/exim[dovecot-sasl,dmarc,dnsdb,dsn,exiscan-acl,maildir,mysql,sasl,spf,-radius] )
	dovecot? ( net-mail/dovecot[bzip2,ipv6,kerberos,lucene,managesieve,mysql,pam,sieve,ssl,tcpd,zlib] )
	spamassassin? ( mail-filter/spamassassin[berkdb,mysql,ipv6,ssl] )
	"

pkg_setup() { :; }
src_unpack() { :; }
src_prepare() { :; }
src_compile() { :; }
src_install() { :; }
pkg_preinst() { :; }
pkg_postinst() { :; }
