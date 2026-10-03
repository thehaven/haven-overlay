# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@dietrichgebert/ponytail"
inherit npm

DESCRIPTION="Lazy senior dev mode for AI agents: skills, code-cutting rulesets, hooks"
HOMEPAGE="https://github.com/DietrichGebert/ponytail"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=net-libs/nodejs-20"
