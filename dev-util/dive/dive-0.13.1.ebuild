# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A tool for exploring each layer in a docker image"
HOMEPAGE="https://github.com/wagoodman/dive"

SRC_URI="
	https://github.com/wagoodman/dive/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

# We must bypass network sandbox because we compile without vendor tarball
# (overlay pragmatic): the ferki/dive -gentoo-deps release assets are
# uploaded per-version and 404 for newer versions.
RESTRICT="network-sandbox"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 MIT MPL-2.0 WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -ldflags "-s -w -X main.version=${PV}" -o build/dive
}

src_install () {
	dobin build/dive
	einstalldocs
}
