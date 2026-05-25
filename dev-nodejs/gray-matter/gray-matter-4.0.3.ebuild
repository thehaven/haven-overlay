# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="gray-matter"
inherit npm

DESCRIPTION="Parse front-matter from a string or file. Fast, reliable and easy to use. Parses YAML front matter by default, but also has support for YAML, JSON, TOML or Coffee Front-Matter, with options to set custom delimiters. Used by metalsmith, assemble, verb and "
HOMEPAGE="https://github.com/jonschlinkert/gray-matter"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/js-yaml
	dev-nodejs/kind-of
	dev-nodejs/section-matter
	dev-nodejs/strip-bom-string
"
BDEPEND="${RDEPEND}"
