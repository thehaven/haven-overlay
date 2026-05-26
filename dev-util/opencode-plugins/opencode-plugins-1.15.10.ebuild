# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta-package for recommended OpenCode plugins"
HOMEPAGE="https://github.com/anomalyco/opencode"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}"

IUSE="+secret-redactor +dcp +conductor snip vibeguard worktree-workflow otel
	+supermemory pty +envsitter-guard +snippets +direnv +composio oh-my-opencode-slim +quota +canvas ntfy +tmux +morph-fast-apply"

RDEPEND="
	dev-util/opencode
	secret-redactor? ( dev-util/opencode-plugin-secret-redactor )
	dcp? ( dev-util/opencode-plugin-dcp )
	conductor? ( dev-util/opencode-plugin-conductor )
	snip? ( dev-util/opencode-snip )
	vibeguard? ( dev-util/opencode-plugin-vibeguard )
	worktree-workflow? ( dev-util/opencode-plugin-worktree-workflow )
	otel? ( dev-util/opencode-plugin-otel )
	supermemory? ( dev-util/opencode-plugin-supermemory )
	pty? ( dev-util/opencode-plugin-pty )
	envsitter-guard? ( dev-util/opencode-plugin-envsitter-guard )
	snippets? ( dev-util/opencode-plugin-snippets )
	direnv? ( dev-util/opencode-plugin-direnv )
	composio? ( dev-util/composio-mcp )
	oh-my-opencode-slim? ( dev-util/oh-my-opencode-slim )
	quota? ( dev-util/opencode-plugin-quota )
	ntfy? ( dev-util/opencode-plugin-ntfy )
	canvas? ( dev-util/opencode-plugin-canvas )
	morph-fast-apply? ( dev-util/opencode-plugin-morph-fast-apply )
	tmux? ( dev-util/opencode-plugin-tmux )
"

src_install() { :; }
