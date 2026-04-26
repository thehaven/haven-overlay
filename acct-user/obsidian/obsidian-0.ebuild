# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for Obsidian headless service"
ACCT_USER_ID=107
ACCT_USER_GROUPS=( obsidian )
ACCT_USER_HOME=/var/lib/obsidian
ACCT_USER_HOME_OWNER=obsidian:obsidian
ACCT_USER_HOME_PERMS=0750

acct-user_add_deps
