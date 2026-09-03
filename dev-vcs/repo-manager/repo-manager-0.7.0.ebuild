# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3 shell-completion systemd

DESCRIPTION="CLI and system daemon for managing git repositories via SQLite catalog"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/haven/repo-manager"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/haven/repo-manager.git"
EGIT_COMMIT="v${PV}"

LICENSE="Apache-2.0"
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
	ego build -ldflags "-s -w -X gitlab-ee.thehavennet.org.uk/haven/repo-manager/cmd.version=v${PV}" -o repo .
	ego build -ldflags "-s -w -X gitlab-ee.thehavennet.org.uk/haven/repo-manager/cmd.version=v${PV}" -o repo-managerd ./cmd/repo-managerd

	# Generate autocompletion scripts
	./repo completion bash > repo.bash || die
	./repo completion zsh > _repo || die
	./repo completion fish > repo.fish || die

	# Generate man pages
	./repo doc --man docs/man || die
}

src_install() {
	dobin repo
	dobin repo-managerd

	newinitd packaging/openrc/repo-managerd.initd repo-managerd
	systemd_dounit packaging/systemd/repo-managerd.service

	keepdir /var/lib/repo-manager
	fowners root:root /var/lib/repo-manager
	fperms 0750 /var/lib/repo-manager

	doman docs/man/*.1

	newbashcomp repo.bash repo
	newzshcomp _repo _repo
	newfishcomp repo.fish repo.fish

	einstalldocs
}
