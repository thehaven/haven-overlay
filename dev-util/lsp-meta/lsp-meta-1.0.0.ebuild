# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta-package for LSP servers — install what you need"
HOMEPAGE="https://github.com/anomalyco/opencode"

S="${WORKDIR}"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="+bash +python +typescript +yaml svelte vue php astro typst go rust terraform"

RDEPEND="
	bash?       ( dev-util/bash-language-server )
	typescript? ( dev-util/typescript-language-server )
	yaml?       ( dev-util/yaml-language-server )
	svelte?     ( dev-util/svelte-language-server )
	vue?        ( dev-util/vue-language-server )
	php?        ( dev-util/intelephense )
	astro?      ( dev-util/astrojs-language-server )
	typst?      ( dev-util/tinymist )
	go?         ( dev-go/gopls )
	python?     ( dev-python/pyright )
	rust?       ( || ( dev-util/rust-analyzer-bin dev-util/rust-analyzer ) )
	terraform?  ( dev-util/terraform-ls )
"

src_install() { :; }
