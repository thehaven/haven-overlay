# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command-line interface to Signal messenger"
HOMEPAGE="https://github.com/AsamK/signal-cli"
SRC_URI="https://github.com/AsamK/signal-cli/releases/download/v${PV}/signal-cli-${PV}-Linux-client.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"

QA_PREBUILT="*"

src_install() {
	newbin signal-cli-client signal-cli
}

pkg_postinst() {
	einfo "signal-cli provides a command-line interface to Signal messenger."
	einfo "Register or link a device:"
	einfo "  signal-cli register     # register new number"
	einfo "  signal-cli link -n NAME # link as secondary device"
}
