# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for Ollama"
ACCT_USER_ID=800
ACCT_USER_GROUPS=( ${PN} )
ACCT_USER_HOME="/usr/share/ollama"
ACCT_USER_HOME_OWNER="ollama:ollama"
ACCT_USER_HOME_PERMS="0755"

acct-user_add_deps
