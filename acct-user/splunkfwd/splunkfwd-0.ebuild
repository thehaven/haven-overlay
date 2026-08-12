# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the Splunk Universal Forwarder"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( splunkfwd )
ACCT_USER_HOME=/opt/splunkforwarder
ACCT_USER_SHELL=/bin/false
acct-user_add_deps
