# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3

DESCRIPTION="MCP server for Terraform operations"
HOMEPAGE="https://github.com/hashicorp/terraform-mcp-server"
EGIT_REPO_URI="file:///storage/home/haven/projects/personal/mcp/terraform-mcp-server"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox"

RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.24"

src_compile() {
	ego build -o terraform-mcp-server ./cmd/terraform-mcp-server
}

src_install() {
	dobin terraform-mcp-server
}
