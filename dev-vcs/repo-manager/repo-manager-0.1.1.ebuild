# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3 shell-completion

DESCRIPTION="Manage all your git repositories: clone, categorise, tag, navigate"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/haven/repo-manager"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/haven/repo-manager.git"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.25.0"

src_unpack() {
	git-r3_src_unpack
	cd "${S}" || die
	ego mod download
}

src_compile() {
	ego build -ldflags "-s -w -X gitlab-ee.thehavennet.org.uk/haven/repo-manager/cmd.version=v${PV}" -o repo . || die
	./repo completion bash > repo.bash || die
	./repo completion zsh > _repo || die
	./repo completion fish > repo.fish || die
}

src_install() {
	dobin repo
	newbashcomp repo.bash repo
	newzshcomp _repo _repo
	newfishcomp repo.fish repo.fish
	einstalldocs
}
