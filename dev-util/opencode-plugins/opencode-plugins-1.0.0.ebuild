# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta-package for recommended OpenCode plugins"
HOMEPAGE="https://github.com/anomalyco/opencode"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+secret-redactor +dcp +conductor snip vibeguard worktree-workflow otel"

RDEPEND="
	dev-util/opencode
	secret-redactor? ( dev-util/opencode-plugin-secret-redactor )
	dcp? ( dev-util/opencode-plugin-dcp )
	conductor? ( dev-util/opencode-plugin-conductor )
	snip? ( dev-util/opencode-snip )
	vibeguard? ( dev-util/opencode-plugin-vibeguard )
	worktree-workflow? ( dev-util/opencode-plugin-worktree-workflow )
	otel? ( dev-util/opencode-plugin-otel )
"

src_install() { :; }
