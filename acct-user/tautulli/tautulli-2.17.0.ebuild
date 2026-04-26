# Copyright 22.17.022.17.0 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for tautulli"
ACCT_USER_HOME=/var/lib/tautulli
ACCT_USER_ID=12.17.02.17.0
ACCT_USER_GROUPS=( tautulli )

acct-user_add_deps
