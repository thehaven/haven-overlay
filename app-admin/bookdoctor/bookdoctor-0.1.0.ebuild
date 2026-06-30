# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Fingerprint, validate, and repair metadata for large ebook libraries"
HOMEPAGE="https://github.com/haven/bookdoctor"
SRC_URI="mirror://local/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/imagehash[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/rapidfuzz[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/httpx-retries[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatchling[${PYTHON_USEDEP}]
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	app-text/texinfo
"

src_compile() {
	distutils-r1_src_compile
	emake -C doc bookdoctor.info
}

src_install() {
	distutils-r1_src_install
	doman man/man1/bookdoctor.1
	doman man/man5/bookdoctor-config.5
	doinfo doc/bookdoctor.info
	insinto /etc/bookdoctor
	newins etc/bookdoctor/config.toml.example config.toml
	fperms 0644 /etc/bookdoctor/config.toml
	keepdir /var/lib/bookdoctor
	fperms 0755 /var/lib/bookdoctor
	einstalldocs
}

pkg_postinst() {
	elog "bookdoctor reads its config in this order (lowest first):"
	elog "  1. bundled defaults"
	elog "  2. ./bookdoctor.toml (project)"
	elog "  3. \$XDG_CONFIG_HOME/bookdoctor/config.toml (user)"
	elog "  4. /etc/bookdoctor/config.toml (system)"
	elog "  5. \$BOOKDOCTOR_CONFIG env var"
	elog "  6. --config FILE CLI flag"
	elog
	elog "See man 5 bookdoctor-config for the full schema, or:"
	elog "  info bookdoctor"
	elog "  bookdoctor --help"
}
