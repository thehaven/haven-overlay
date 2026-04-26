# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="mem0 user"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( mem0 )
ACCT_USER_HOME=/var/lib/mem0
