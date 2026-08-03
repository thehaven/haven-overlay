# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

# User for Apache Solr. UID 8983 mirrors the official Docker image
# (https://hub.docker.com/_/solr) so files written by a Docker-deployed
# Solr can be chowned by the overlay ebuild without ACL drift.
DESCRIPTION="User for Apache Solr"
KEYWORDS="~amd64 ~arm64"
ACCT_USER_ID=8983
ACCT_USER_GROUPS=( solr )

acct-user_add_deps
