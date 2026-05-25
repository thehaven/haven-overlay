# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="opencode-ntfy.sh"
inherit npm

DESCRIPTION="OpenCode plugin that sends push notifications via ntfy.sh"
HOMEPAGE="https://github.com/lannuttia/opencode-ntfy.sh#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/iso8601-duration
	dev-nodejs/opencode-notification-sdk
"
BDEPEND="${RDEPEND}"
