# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dependency Manager for PHP"
HOMEPAGE="https://github.com/composer/composer"
SRC_URI="
	https://github.com/composer/composer/releases/download/${PV}/composer.phar
	https://github.com/composer/composer/releases/download/${PV}/composer.phar.asc
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-lang/php:*[curl,phar,ssl]
	>=dev-lang/php-7.2.5"
S="${WORKDIR}"

src_unpack() {
	# PHAR is installed as-is; do not attempt to extract
	:
}

src_install() {
	newbin "${DISTDIR}/composer.phar" "composer"
	fperms +x "/usr/bin/composer"

	# Document the GPG signing key
	dodoc "${DISTDIR}/composer.phar.asc"
}

pkg_postinst() {
	elog "Composer ${PV} has been installed as /usr/bin/composer"
	elog "Verify with: composer --version"
	elog "Update with: composer self-update"
	elog ""
	elog "The PHAR is signed by Jordi Boggiano (key from https://composer.github.io/pubkeys.gpg)"
	elog "Verify with: gpg --verify /usr/share/doc/composer-${PV}/composer.phar.asc /usr/bin/composer"
}
