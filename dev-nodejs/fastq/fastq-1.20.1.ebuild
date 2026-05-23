# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="fastq"

inherit npm

DESCRIPTION="Fast, in memory work queue"
HOMEPAGE="https://github.com/mcollina/fastq#readme"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/reusify
"
BDEPEND=""
