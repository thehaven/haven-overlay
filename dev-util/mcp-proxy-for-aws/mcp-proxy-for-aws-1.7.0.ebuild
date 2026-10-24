# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="mcp-proxy-for-aws"
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Thin proxy for the managed (AWS-hosted) AWS MCP Server"
HOMEPAGE="https://github.com/aws/mcp-proxy-for-aws"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Upstream declares: fastmcp>=3.2,<3.5 / httpx>=0.27.1,<1.0 / boto3>=1.41.0 /
# botocore[crt]>=1.41.0. The ranges are reproduced faithfully so that a
# fastmcp 4.x resolution cannot silently happen at resolve time -- the
# `>=dev-python/fastmcp-4.0.0` mask only bites at install time.
#
# DIVERGENCE -- the `crt` extra of botocore is NOT declared here.
# Upstream's `botocore[crt]` extra resolves to `awscrt==0.36.0`, and awscrt
# has no ebuild in the Gentoo tree or in this overlay. The proxy's own
# source contains no awscrt / botocore.crt import, so the extra is not
# exercised by this package; declaring it would make the atom unsatisfiable
# on every host. Packaging awscrt (a Rust-backed build) is a separate
# follow-up. See openspec/changes/replace-aws-api-mcp-with-aws-mcp-server/.
RDEPEND="
	>=dev-python/boto3-1.41.0[${PYTHON_USEDEP}]
	>=dev-python/botocore-1.41.0[${PYTHON_USEDEP}]
	>=dev-python/fastmcp-3.2[${PYTHON_USEDEP}]
	<dev-python/fastmcp-3.5[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27.1[${PYTHON_USEDEP}]
	<dev-python/httpx-1.0[${PYTHON_USEDEP}]
"

# NOTE: no src_prepare() build-backend fix-up is carried over from
# dev-util/mcp-server-aws. That ebuild rewrites `build-backend = "uv_build"`
# because *that* distribution declared uv_build. The 1.7.0 sdist declares
# `build-backend = "hatchling.build"` already (verified by unpacking the
# sdist and reading its pyproject.toml), so a rewrite would be cargo-culting.
# Never assume siblings share a build backend.

# Upstream ships a separate wrapper distribution, `mcp-proxy-for-aws-cli`,
# whose metadata pins `mcp-proxy-for-aws` to the wrapper's own version. The
# two must move in lockstep: a bump of one without the other leaves the
# wrapper pinning a release this ebuild has just superseded. This ebuild
# packages the proxy itself, so the constraint is recorded here rather than
# silently ignored.

python_test() {
	# Import the console-script TARGET, not the distribution package name.
	# The thing clients invoke is mcp_proxy_for_aws.server:main, and the
	# console script is the artefact the native path depends on. Assert
	# both, so a broken module or a missing script is a build failure
	# rather than a runtime surprise.
	"${EPYTHON}" -c "import mcp_proxy_for_aws.server" \
		|| die "❌ Import test failed: mcp_proxy_for_aws.server could not be imported"
	einfo "✅ Import successful: mcp_proxy_for_aws.server"

	[[ -x /usr/bin/mcp-proxy-for-aws ]] \
		|| die "❌ Console script test failed: /usr/bin/mcp-proxy-for-aws is missing"
	einfo "✅ Console script present: /usr/bin/mcp-proxy-for-aws"
}

pkg_postinst() {
	elog ""
	elog "MIGRATION NOTICE -- this package replaces dev-util/mcp-server-aws."
	elog "The retired AWS API MCP server ran LOCALLY. This proxy forwards to"
	elog "the MANAGED, AWS-HOSTED AWS MCP Server, so API execution now happens"
	elog "AWS-side. Every retired tool is gone:"
	elog "    call_aws            -> removed (use aws___run_script)"
	elog "    suggest_aws_commands -> removed"
	elog "    get_execution_plan  -> removed"
	elog "Live tool list (verified against the managed server on 2026-10-24):"
	elog "aws___run_script (sandboxed Python), aws___search_documentation,"
	elog "aws___read_documentation, aws___retrieve_skill, aws___list_regions,"
	elog "aws___get_regional_availability, aws___get_presigned_url, aws___get_tasks."
	elog "NOTE: upstream's migration guide names aws___call_aws as the rename of"
	elog "call_aws. The live managed server does NOT expose that tool;"
	elog "aws___run_script is the functional replacement. Verified by querying"
	elog "the endpoint directly, bypassing the proxy."
	elog ""
	elog "DELETE the old local AWS API MCP server entry (the one from the"
	elog "dev-util/mcp-server-aws package) from your MCP client configuration."
	elog "Running both at once causes tool-name conflicts."
	elog "Remove any hardcoded 'call_aws' references from skills, context files,"
	elog "prompts and steering documents -- they will silently stop working."
	elog "See https://github.com/aws/agent-toolkit-for-aws/blob/main/rules/aws-agent-rules.md"
	elog ""
	elog "Two INDEPENDENT Regions are in play:"
	elog "    the endpoint URL Region  -- where the managed server runs"
	elog "    --metadata AWS_REGION   -- the Region operations are performed in"
	elog "If --metadata AWS_REGION is omitted, operations default to us-east-1."
	elog "The placeholder below is deliberately invalid so that a verbatim paste"
	elog "fails loudly rather than silently running in the wrong Region."
	elog ""
	elog "Client setup (native path -- no runtime package resolver is used):"
	elog ""
	elog "  Gemini CLI  (~/.gemini/settings.json):"
	elog "    {"
	elog "      \"mcpServers\": {"
	elog "        \"aws-mcp\": {"
	elog "          \"command\": \"/usr/bin/mcp-proxy-for-aws\","
	elog "          \"args\": ["
	elog "            \"https://aws-mcp.us-east-1.api.aws/mcp\","
	elog "            \"--metadata\","
	elog "            \"AWS_REGION=REPLACE_WITH_OPERATIONS_REGION\""
	elog "          ],"
	elog "          \"timeout\": 100000,"
	elog "          \"transport\": \"stdio\""
	elog "        }"
	elog "      }"
	elog "    }"
	elog ""
	elog "  Claude Desktop  (~/.config/Claude/claude_desktop_config.json):"
	elog "    {"
	elog "      \"mcpServers\": {"
	elog "        \"aws-mcp\": {"
	elog "          \"command\": \"/usr/bin/mcp-proxy-for-aws\","
	elog "          \"args\": ["
	elog "            \"https://aws-mcp.us-east-1.api.aws/mcp\","
	elog "            \"--metadata\","
	elog "            \"AWS_REGION=REPLACE_WITH_OPERATIONS_REGION\""
	elog "          ],"
	elog "          \"timeout\": 100000,"
	elog "          \"transport\": \"stdio\""
	elog "        }"
	elog "      }"
	elog "    }"
	elog ""
	elog "  OpenCode  (~/.config/opencode/opencode.json):"
	elog "    {"
	elog "      \"mcp\": {"
	elog "        \"aws-mcp\": {"
	elog "          \"type\": \"local\","
	elog "          \"command\": ["
	elog "            \"/usr/bin/mcp-proxy-for-aws\","
	elog "            \"https://aws-mcp.us-east-1.api.aws/mcp\","
	elog "            \"--metadata\","
	elog "            \"AWS_REGION=REPLACE_WITH_OPERATIONS_REGION\""
	elog "          ],"
	elog "          \"enabled\": true"
	elog "        }"
	elog "      }"
	elog "    }"
	elog ""
	elog "CREDENTIALS: API execution moves AWS-side, but SigV4 request signing"
	elog "stays LOCAL and the proxy still uses this host's credential chain"
	elog "(aws configure / aws login / the local AWS profile). This is NOT a"
	elog "zero-credential-exposure configuration."
	elog ""
	elog "The packaged atom IS the pin: the client configuration names the"
	elog "native path above and never resolves the proxy through a runtime"
	elog "package resolver, so no transitive dependency can drift to 'latest'."
	elog ""
}
