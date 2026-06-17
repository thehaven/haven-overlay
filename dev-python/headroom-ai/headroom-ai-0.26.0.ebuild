# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=maturin
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{12..14} )

# Native Rust extension via PyO3
DISTUTILS_EXT=1

inherit distutils-r1 optfeature

DESCRIPTION="Context optimization layer for LLM applications — compresses context by 60-95%"
HOMEPAGE="https://github.com/chopratejas/headroom"
SRC_URI="https://github.com/chopratejas/headroom/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

# GitHub archives extract to <repo>-<tag>, not <pn>-<pv>
S="${WORKDIR}/headroom-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Upstream provides optional extras: proxy, ml, memory, image, code, voice, etc.
# We expose proxy and code as the most commonly used extras.
IUSE="code proxy debug test"

# Tests exist upstream but require a large ML dependency chain
# (onnxruntime, transformers, torch) not yet packaged.
RESTRICT="test network-sandbox"

src_compile() {
	export PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1
	distutils-r1_src_compile
}

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Core (runtime — needed even without USE flags)
RDEPEND="
        ${PYTHON_DEPS}
        $(python_gen_cond_dep '
                dev-python/tiktoken[${PYTHON_USEDEP}]
                >=dev-python/pydantic-2.0.0[${PYTHON_USEDEP}]
                >=dev-python/click-8.1.0[${PYTHON_USEDEP}]
                >=dev-python/rich-13.0.0[${PYTHON_USEDEP}]
                >=dev-python/opentelemetry-api-1.24.0[${PYTHON_USEDEP}]
                >=dev-python/ast-grep-cli-0.30.0[${PYTHON_USEDEP}]
        ')
        >=dev-ml/litellm-1.83.3[${PYTHON_SINGLE_USEDEP}]
"

# Proxy extra: HTTP proxy, MCP server, content detection, ML compression
RDEPEND+="
        proxy? (
                >=dev-ml/litellm-1.83.3[${PYTHON_SINGLE_USEDEP}]
                >=sci-ml/transformers-4.30.0[${PYTHON_SINGLE_USEDEP}]
                $(python_gen_cond_dep '
                        >=dev-python/fastapi-0.100.0[${PYTHON_USEDEP}]
                        >=dev-python/uvicorn-0.26.0[${PYTHON_USEDEP}]
                        >=dev-python/httpx-0.26.0[${PYTHON_USEDEP}]
                        >=dev-python/openai-2.14.0[${PYTHON_USEDEP}]
                        >=dev-python/mcp-1.0.0[${PYTHON_USEDEP}]
                        >=dev-python/zstandard-0.20.0[${PYTHON_USEDEP}]
                        >=dev-python/websockets-13.0[${PYTHON_USEDEP}]
                        >=dev-python/watchdog-4.0.0[${PYTHON_USEDEP}]
                        >=dev-python/sqlite-vec-0.1.6[${PYTHON_USEDEP}]
                        >=dev-python/magika-1.0.0[${PYTHON_USEDEP}]
                        >=dev-python/onnxruntime-1.16.0[${PYTHON_USEDEP}]
                ')
        )
"

# Code extra: tree-sitter AST-aware code compression
RDEPEND+="
        code? (
                $(python_gen_cond_dep '
                        >=dev-python/tree-sitter-language-pack-0.10.0[${PYTHON_USEDEP}]
                ')
        )
"

BDEPEND="
        ${PYTHON_DEPS}
        dev-util/maturin
        || ( dev-lang/rust dev-lang/rust-bin )
"

pkg_postinst() {
        optfeature "HTTP proxy server (headroom proxy)" dev-python/fastapi dev-python/uvicorn dev-python/httpx
        optfeature "MCP server support" dev-python/mcp
        optfeature "AST-aware code compression" dev-python/tree-sitter-language-pack
        optfeature "Vector memory for RAG" dev-python/sqlite-vec
        optfeature "ML content detection (ContentRouter)" dev-python/magika
        optfeature "Kompress ONNX text compression" dev-python/onnxruntime
        optfeature "Transformers support for Kompress" sci-ml/transformers
}
