# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta-package for recommended OpenCode plugins"
HOMEPAGE="https://github.com/anomalyco/opencode"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	~dev-util/opencode-plugin-secret-redactor-0.5.1
	~dev-util/opencode-plugin-dcp-3.1.11
	~dev-util/opencode-plugin-conductor-1.32.0
"
