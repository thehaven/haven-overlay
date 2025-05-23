# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3

DESCRIPTION="Docker container metadata generator for templated files"
HOMEPAGE="https://github.com/nginx-proxy/docker-gen"
EGIT_REPO_URI="https://github.com/nginx-proxy/${PN}.git"

LICENSE="MIT"
SLOT="0"
IUSE="debug test"

# Required for Go module downloads and git operations
RESTRICT="network-sandbox !test? ( test )"

RDEPEND="
	acct-group/docker
	app-containers/docker
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-lang/go-1.20
	test? ( dev-go/testify )
"

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_prepare() {
	default
	eapply_user
}

src_compile() {
	local mygoargs=(
		-v
		-work
		-x
		$(usex debug "-tags=debug" "")
	)

	export GOMAXPROCS=1
	ego build "${mygoargs[@]}" -o bin/${PN} ./cmd/docker-gen
}

src_test() {
	ego test -v ./...
}

src_install() {
	dobin bin/${PN}
	dodoc README.md
	if [[ -d docs ]]; then
		dodoc -r docs/* || die
	fi

	fowners root:docker /usr/bin/${PN}
	fperms 0750 /usr/bin/${PN}
}

pkg_postinst() {
	einfo "To use docker-gen, ensure your user is in the 'docker' group:"
	einfo "    usermod -a -G docker <user>"
	einfo
	einfo "You may need to restart your session for changes to take effect"
}
