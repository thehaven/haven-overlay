# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8
inherit acct-user
DESCRIPTION="User for OWASP Dependency-Check database updates"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( dependency-check )
ACCT_USER_HOME=/var/lib/dependency-check
acct-user_add_deps
