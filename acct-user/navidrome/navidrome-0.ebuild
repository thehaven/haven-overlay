# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for navidrome"
ACCT_USER_ID=973
ACCT_USER_HOME=/var/lib/navidrome
ACCT_USER_GROUPS=( navidrome )

acct-user_add_deps
