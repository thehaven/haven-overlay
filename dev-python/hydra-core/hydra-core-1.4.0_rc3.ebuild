# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Hydra: A framework for configuring complex applications"
HOMEPAGE="https://github.com/facebookresearch/hydra"
# Portage spells a release candidate 1.4.0_rc3; the upstream tag is v1.4.0rc1.
# Drop the underscore so every version maps onto its upstream tag, and reuse the
# same string for the unpack directory (GitHub strips the leading "v" from the
# top-level directory of a tag archive).
MY_PV="${PV/_/}"
SRC_URI="https://github.com/facebookresearch/hydra/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/hydra-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/omegaconf
	dev-python/packaging
"
