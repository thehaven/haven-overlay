# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for MCP services"
ACCT_USER_ID=360
ACCT_USER_GROUPS=( mcp )
ACCT_USER_HOME=/var/lib/mcp
