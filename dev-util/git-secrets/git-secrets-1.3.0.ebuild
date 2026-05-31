# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Prevents committing secrets and credentials into git repos"
HOMEPAGE="https://github.com/awslabs/git-secrets"
SRC_URI="https://github.com/awslabs/git-secrets/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="dev-vcs/git"

src_install() {
	dobin git-secrets
	doman git-secrets.1
	einstalldocs
}
