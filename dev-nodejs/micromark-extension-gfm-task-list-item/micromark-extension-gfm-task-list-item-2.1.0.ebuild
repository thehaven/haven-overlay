# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="micromark-extension-gfm-task-list-item"
inherit npm

DESCRIPTION="micromark extension to support GFM task list items"
HOMEPAGE="https://github.com/micromark/micromark-extension-gfm-task-list-item#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/devlop
	dev-nodejs/micromark-factory-space
	dev-nodejs/micromark-util-character
	dev-nodejs/micromark-util-symbol
	dev-nodejs/micromark-util-types
"
BDEPEND="${RDEPEND}"
