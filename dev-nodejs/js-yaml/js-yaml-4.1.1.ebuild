# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="js-yaml"


DESCRIPTION="YAML 1.2 parser and serializer"
HOMEPAGE="https://github.com/nodeca/js-yaml#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/argparse
"
BDEPEND=""
