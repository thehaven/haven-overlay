# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Script for creating hybrid swap space from zram swaps, swap files and swap partitions."
HOMEPAGE="https://github.com/Nefelim4ag/systemd-swap"
SRC_URI="https://github.com/Nefelim4ag/systemd-swap/archive/${PV}.tar.gz"

LICENSE="GPL-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/systemd"
RDEPEND="${DEPEND}"
