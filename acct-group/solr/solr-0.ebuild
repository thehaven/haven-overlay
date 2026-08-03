# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-group

# GID 8983 mirrors the official Solr Docker image so volumes mounted
# across Docker + overlay deployments keep consistent ownership.
DESCRIPTION="Group for Apache Solr"
KEYWORDS="~amd64 ~arm64"
ACCT_GROUP_ID=8983
