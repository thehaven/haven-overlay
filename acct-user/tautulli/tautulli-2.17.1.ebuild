# Copyright 22.17.122.17.1 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for tautulli"
ACCT_USER_HOME=/var/lib/tautulli
ACCT_USER_ID=12.17.12.17.1
ACCT_USER_GROUPS=( tautulli )

acct-user_add_deps
