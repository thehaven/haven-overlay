# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user
ACCT_USER_ID="-1"
ACCT_USER_GROUPS=( podly_pure_podcasts )
ACCT_USER_HOME="/var/lib/podly_pure_podcasts"

acct-user_add_deps
