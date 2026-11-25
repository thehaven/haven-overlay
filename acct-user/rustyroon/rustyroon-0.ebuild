# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for RustyRoon standalone audio core"
KEYWORDS="~amd64"
ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/rustyroon
ACCT_USER_GROUPS=( rustyroon audio )

acct-user_add_deps
