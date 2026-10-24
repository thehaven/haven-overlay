# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta-package for all MCP servers"
HOMEPAGE="https://github.com/rusiaaman/wcgw"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

# NOTE: USE=aws now selects dev-util/mcp-proxy-for-aws, the thin proxy for the
# managed, AWS-hosted AWS MCP Server. The previous target,
# dev-util/mcp-server-aws (the self-hosted awslabs/aws-api-mcp-server), is
# end-of-life upstream and is masked in profiles/package.mask; its ebuild is
# retained on disk so it stays recoverable by removing one mask line.
#
# This is a SEMANTIC change, not a rename: the flag still reads "aws", but the
# server it selects is now remote and managed by AWS rather than a local
# process. The credentials, the Region semantics and the tool names all differ:
#   - tool names: call_aws -> aws___call_aws; suggest_aws_commands and
#     get_execution_plan are gone; several new tools are added.
#   - the endpoint is AWS-hosted; the proxy still signs requests locally with
#     SigV4, so the local credential chain remains in use.
#   - the two Regions are independent: the endpoint URL carries the Region the
#     MCP server runs in, and --metadata AWS_REGION= carries the Region that
#     operations default to.
# Hosts that relied on the local server must delete the old client entry, not
# add alongside the new one: two entries produce conflicting tool names.
# See the successor's pkg_postinst migration notice and the upstream guide:
# https://github.com/awslabs/mcp/blob/main/src/aws-api-mcp-server/MIGRATION.md

IUSE="ai-compressor alertmanager analyzer aws brave-search chrome-devtools-mcp composio context7 cortex desktop-commander docfork docker fetch filesystem forge gemini-deepsearch git github github-mcp-server gitlab gitmcp grafana headroom jc karakeep kubernetes librenms linkedin markdownlint mediawiki mem0 mesh network-tools obsidian opentofu pagerduty paperclip pass perplexity perplexity-ask perplexity-community playwright plur postgres powerpoint pytest ripgrep sentry serena sequential-thinking skillspector slack stele task-manager terraform time tree-sitter +wcgw wikipedia"

RDEPEND="
	ai-compressor? ( app-misc/ai-compressor )
	alertmanager? ( dev-util/mcp-alertmanager )
	analyzer? ( dev-util/mcp-server-analyzer )
	aws? ( dev-util/mcp-proxy-for-aws )
	brave-search? ( dev-util/mcp-server-brave-search )
	chrome-devtools-mcp? ( dev-util/chrome-devtools-mcp )
	composio? ( dev-util/composio-mcp )
	context7? ( dev-util/mcp-server-context7 )
	cortex? ( app-misc/cortex )
	desktop-commander? ( dev-util/mcp-server-desktop-commander )
	docfork? ( dev-util/mcp-server-docfork )
	docker? ( dev-util/mcp-server-docker )
	fetch? ( dev-util/mcp-server-fetch )
	filesystem? ( dev-util/mcp-server-filesystem )
	forge? ( app-admin/mcp-forge )
	gemini-deepsearch? ( dev-util/mcp-server-gemini-deepsearch )
	git? ( dev-util/mcp-server-git )
	github? ( dev-util/mcp-server-github )
	github-mcp-server? ( dev-util/github-mcp-server )
	gitlab? ( dev-util/mcp-server-gitlab )
	gitmcp? ( dev-util/mcp-server-gitmcp )
	grafana? ( dev-util/mcp-grafana )
	headroom? ( dev-python/headroom-ai )
	jc? ( dev-python/jc-mcp )
	karakeep? ( dev-util/mcp-server-karakeep )
	kubernetes? ( dev-util/mcp-server-kubernetes )
	librenms? ( dev-python/clr-librenms-mcp )
	linkedin? ( dev-util/mcp-server-linkedin )
	markdownlint? ( dev-util/mcp-server-markdownlint )
	mediawiki? ( dev-util/mediawiki-mcp-server )
	mem0? ( app-misc/mem0-mcp )
	mesh? ( app-admin/mcp-mesh )
	network-tools? ( dev-util/mcp-server-network-tools )
	obsidian? ( dev-util/obsidian-mcp )
	opentofu? ( dev-util/mcp-server-opentofu )
	pagerduty? ( dev-util/mcp-pagerduty )
	paperclip? ( app-misc/paperclip-mcp )
	pass? ( dev-util/mcp-server-pass )
	perplexity? ( dev-util/mcp-server-perplexity )
	perplexity-ask? ( dev-util/mcp-server-perplexity-ask )
	perplexity-community? ( dev-util/mcp-server-perplexity-community )
	playwright? ( dev-util/mcp-server-playwright )
	plur? ( app-misc/plur-mcp )
	postgres? ( dev-util/mcp-postgres )
	powerpoint? ( dev-util/mcp-server-powerpoint )
	pytest? ( dev-util/mcp-server-pytest )
	ripgrep? ( dev-util/mcp-server-ripgrep )
	sentry? ( dev-util/mcp-sentry )
	serena? ( dev-python/serena-agent )
	sequential-thinking? ( dev-util/mcp-server-sequential-thinking )
	skillspector? ( app-vuln/skillspector[mcp] )
	slack? ( dev-util/mcp-slack )
	stele? ( app-admin/stele[mcp] )
	task-manager? ( dev-util/mcp-server-task-manager )
	terraform? ( app-admin/terraform-mcp-server )
	time? ( dev-python/mcp-server-time )
	tree-sitter? ( dev-util/mcp-server-tree-sitter )
	wcgw? ( dev-util/mcp-server-wcgw )
	wikipedia? ( dev-util/mediawiki-mcp-server )
"
