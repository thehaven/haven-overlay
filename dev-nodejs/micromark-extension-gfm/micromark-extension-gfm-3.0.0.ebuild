# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="micromark-extension-gfm"


DESCRIPTION="micromark extension to support GFM (GitHub Flavored Markdown)"
HOMEPAGE="https://github.com/micromark/micromark-extension-gfm#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/micromark-extension-gfm-autolink-literal
	dev-nodejs/micromark-extension-gfm-footnote
	dev-nodejs/micromark-extension-gfm-strikethrough
	dev-nodejs/micromark-extension-gfm-table
	dev-nodejs/micromark-extension-gfm-tagfilter
	dev-nodejs/micromark-extension-gfm-task-list-item
	dev-nodejs/micromark-util-combine-extensions
	dev-nodejs/micromark-util-types
"
BDEPEND=""
