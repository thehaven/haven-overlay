# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

DESCRIPTION="High performance Node.js image processing, the fastest module to resize JPEG,..."
HOMEPAGE="https://sharp.pixelplumbing.com"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT='*.node'
RESTRICT='strip'

RDEPEND=""
BDEPEND="${RDEPEND}"
