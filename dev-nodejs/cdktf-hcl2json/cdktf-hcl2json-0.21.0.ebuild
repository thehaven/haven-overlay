# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@cdktf/hcl2json"

inherit npm

DESCRIPTION="Transform HCL into JSON"
HOMEPAGE="https://github.com/hashicorp/terraform-cdk#readme"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/fs-extra
"
BDEPEND=""
