# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta-package for all MCP servers"
HOMEPAGE="https://github.com/rusiaaman/wcgw"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

IUSE="ai-compressor alertmanager analyzer atlassian aws brave-search context7 desktop-commander docfork docker fetch git github gitlab gitmcp grafana jc karakeep kubernetes markdownlint mediawiki mem0 memory network-tools obsidian opentofu pagerduty pass perplexity playwright powerpoint pytest ripgrep sentry sequential-thinking task-manager tree-sitter +wcgw wikipedia"

RDEPEND="
	ai-compressor? ( app-misc/ai-compressor )
	alertmanager? ( dev-util/mcp-alertmanager )
	analyzer? ( dev-util/mcp-server-analyzer )
	aws? ( dev-util/mcp-server-aws )
	brave-search? ( dev-util/mcp-server-brave-search )
	context7? ( dev-util/mcp-server-context7 )
	desktop-commander? ( dev-util/mcp-server-desktop-commander )
	docfork? ( dev-util/mcp-server-docfork )
	docker? ( dev-util/mcp-server-docker )
	fetch? ( dev-util/mcp-server-fetch )
	git? ( dev-util/mcp-server-git )
	github? ( dev-util/mcp-server-github )
	gitlab? ( dev-util/mcp-server-gitlab )
	gitmcp? ( dev-util/mcp-server-gitmcp )
	grafana? ( dev-util/mcp-grafana )
	jc? ( dev-python/jc-mcp )
	karakeep? ( dev-util/mcp-server-karakeep )
	kubernetes? ( dev-util/mcp-server-kubernetes )
	markdownlint? ( dev-util/mcp-server-markdownlint )
	mediawiki? ( dev-util/mediawiki-mcp-server )
	mem0? ( app-misc/mem0-mcp )
	memory? ( dev-util/mcp-server-memory )
	network-tools? ( dev-util/mcp-server-network-tools )
	obsidian? ( dev-util/obsidian-mcp )
	opentofu? ( dev-util/mcp-server-opentofu )
	pagerduty? ( dev-util/mcp-pagerduty )
	pass? ( dev-util/mcp-server-pass )
	perplexity? ( dev-util/mcp-server-perplexity )
	playwright? ( dev-util/mcp-server-playwright )
	powerpoint? ( dev-util/mcp-server-powerpoint )
	pytest? ( dev-util/mcp-server-pytest )
	ripgrep? ( dev-util/mcp-server-ripgrep )
	sentry? ( dev-util/mcp-sentry )
	sequential-thinking? ( dev-util/mcp-server-sequential-thinking )
	task-manager? ( dev-util/mcp-server-task-manager )
	tree-sitter? ( dev-util/mcp-server-tree-sitter )
	wcgw? ( dev-util/mcp-server-wcgw )
	wikipedia? ( dev-util/mediawiki-mcp-server )
"
