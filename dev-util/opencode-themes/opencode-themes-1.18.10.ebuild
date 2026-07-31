# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta-package for recommended OpenCode themes"
HOMEPAGE="https://github.com/anomalyco/opencode"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}"

IUSE="+poimandres +dracula"

RDEPEND="
	dev-util/opencode
	poimandres? ( dev-util/opencode-theme-poimandres )
	dracula? ( dev-util/opencode-theme-dracula )
"

src_install() { :; }
