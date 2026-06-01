# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="is-inside-container"
inherit npm

DESCRIPTION="Check if the process is running inside a container (Docker/Podman)"
HOMEPAGE="https://github.com/sindresorhus/is-inside-container#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/is-docker
"
BDEPEND="${RDEPEND}"
