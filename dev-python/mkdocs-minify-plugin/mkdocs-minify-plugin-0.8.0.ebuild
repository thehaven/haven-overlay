# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="An MkDocs plugin to minify HTML, JS or CSS files prior to being written to disk"
HOMEPAGE="
	https://github.com/byrnereese/mkdocs-minify-plugin
	https://pypi.org/project/mkdocs-minify-plugin/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/csscompressor-0.9.5[${PYTHON_USEDEP}]
	>=dev-python/htmlmin2-0.1.13[${PYTHON_USEDEP}]
	>=dev-python/jsmin-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.4.1[${PYTHON_USEDEP}]
"
# Upstream test suite (tests/test_basic.py) requires tests/fixtures/, which is
# missing from the published PyPI sdist (upstream packaging defect). Run an
# inline smoke test against the plugin's minify surface instead.
IUSE="test"
RESTRICT="!test? ( test )"

python_test() {
	python - <<-'EOF_TEST' || die "mkdocs-minify-plugin smoke test failed"
from mkdocs_minify_plugin.plugin import MinifyPlugin, MINIFIERS

css = "  .ui-hidden { display: none; }  "
out_css = MINIFIERS["css"](css)
assert out_css == ".ui-hidden{display:none}", out_css

js = "console.log( 'Hello World' );"
out_js = MINIFIERS["js"](js, quote_chars="'\"`")
assert out_js == "console.log('Hello World');", out_js

p = MinifyPlugin()
assert p._minify_file_data_with_func(css, MINIFIERS["css"]) == ".ui-hidden{display:none}"
# config is populated by load_config(), not __init__()
p.load_config({"minify_html": False})
assert p._minify_html_page("<p>hello</p>") == "<p>hello</p>"
p.config["minify_html"] = True
minified_html = p._minify_html_page("<p>hello</p>")
assert minified_html == "<p>hello</p>", minified_html
EOF_TEST
}
