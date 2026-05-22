# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8
inherit acct-user
DESCRIPTION="User for Trivy database updates"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( trivy )
ACCT_USER_HOME=/var/lib/trivy
acct-user_add_deps
