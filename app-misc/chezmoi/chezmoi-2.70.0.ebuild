# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="Manage your dotfiles across multiple diverse machines, securely"
HOMEPAGE="https://chezmoi.io/"
SRC_URI="https://github.com/twpayne/chezmoi/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	https://github.com/twpayne/chezmoi/releases/download/v${PV}/${P}-deps.tar.xz"
S="${WORKDIR}/${P}"

LICENSE="MIT"
LICENSE+=" Apache-2.0 BSD BSD-2 MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

# chezmoi v2.70.0 declares go 1.25.7 in its go.mod; the Gentoo
# go-module.eclass defaults to >=go-1.20, so override to the actual
# upstream requirement.
BDEPEND=">=dev-lang/go-1.25.7"

src_compile() {
	ego build -v -o "${PN}" -ldflags "-s -w
		-X main.version=${PV}
		-X main.commit=release
		-X main.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)
		-X main.builtBy=portage" .
}

src_test() {
	# Run the upstream test suite. Tests live under internal/ and
	# include a TestMain sanity check in main_test.go. The full
	# suite runs ~90 packages; honour -p $(nproc).
	ego test -short -p "$(nproc)" ./...
}

src_install() {
	dobin "${PN}"

	# Shell completions (pre-generated under completions/ in the
	# upstream tarball; see main.go go:generate lines).
	newbashcomp completions/"${PN}-completion.bash" "${PN}"
	dozshcomp completions/"${PN}.zsh"
	newzshcomp completions/"${PN}.zsh" "_${PN}"
	dofishcomp completions/"${PN}.fish"

	# Upstream README, LICENSE, and assets/ install scripts.
	einstalldocs

	# Install upstream install helpers under /usr/share/chezmoi/scripts.
	insinto /usr/share/${PN}/scripts
	doins -r assets/scripts/*

	# Make the upstream install scripts executable. fperms is
	# relative to $D; explicit per-file paths avoid the zsh glob
	# behaviour where a non-matching pattern aborts the script.
	fperms 0755 /usr/share/${PN}/scripts/install.sh
	fperms 0755 /usr/share/${PN}/scripts/install-local-bin.sh
	fperms 0755 /usr/share/${PN}/scripts/stow-to-chezmoi.sh
}

pkg_postinst() {
	elog "chezmoi ships install helpers under /usr/share/${PN}/scripts/."
	elog "Run 'chezmoi init <repo>' to bootstrap a dotfile repo, or"
	elog "curl -fsSL https://get.chezmoi.io | sh for the upstream bootstrapper."
}
