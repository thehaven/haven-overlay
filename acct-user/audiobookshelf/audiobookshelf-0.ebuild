# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

KEYWORDS="~amd64"

DESCRIPTION="user for audiobookshelf"
ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/audiobookshelf
ACCT_USER_GROUPS=( audiobookshelf )

acct-user_add_deps
