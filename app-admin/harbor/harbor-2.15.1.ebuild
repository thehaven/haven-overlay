# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta-package for Project Harbor"
HOMEPAGE="https://github.com/goharbor/harbor"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

# Suggested packages enabled by default: redis, postgres, nginx, trivy
IUSE="+core +portal +jobservice +registryctl +prepare +redis +postgres +nginx +trivy"

RDEPEND="
	core? ( ~app-admin/harbor-core-${PV} )
	portal? ( ~www-apps/harbor-portal-${PV} )
	jobservice? ( ~app-admin/harbor-jobservice-${PV} )
	registryctl? ( ~app-admin/harbor-registryctl-${PV} )
	prepare? ( ~app-admin/harbor-prepare-${PV} )
	redis? ( dev-db/redis )
	postgres? ( dev-db/postgresql )
	nginx? ( www-servers/nginx )
	trivy? ( app-admin/trivy )
"
