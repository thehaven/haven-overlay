# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Docker container metadata generator for templated files"
HOMEPAGE="https://github.com/nginx-proxy/docker-gen"

# Verified source URL
SRC_URI="https://github.com/nginx-proxy/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

# Required for Go module downloads
RESTRICT="network-sandbox"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Using existing USE flags from Gentoo repository
IUSE="debug test"

# Runtime dependencies
RDEPEND="
	acct-group/docker
	app-containers/docker
"

# Build dependencies
DEPEND="${RDEPEND}"

# Build tool dependencies
BDEPEND="
	>=dev-lang/go-1.20
	test? ( dev-go/testify )
"

# Test restrictions
RESTRICT+=" !test? ( test )"

src_unpack() {
	default
	go-module_src_unpack
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

	# Documentation
	dodoc README.md
	if [[ -d docs ]]; then
		dodoc -r docs/* || die
	fi

	# Ensure correct permissions
	fowners root:docker /usr/bin/${PN}
	fperms 0750 /usr/bin/${PN}
}

pkg_postinst() {
	einfo "To use docker-gen, ensure your user is in the 'docker' group:"
	einfo "    usermod -a -G docker <user>"
	einfo
	einfo "You may need to restart your session for changes to take effect"
}
