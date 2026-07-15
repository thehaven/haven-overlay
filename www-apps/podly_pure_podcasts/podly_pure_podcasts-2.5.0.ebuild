# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# KNOWN HOST-ENVIRONMENT MISMATCH.
# Upstream pyproject.toml declares `requires-python = ">=3.11,<3.12"`, i.e.
# python3.11 only. This host's /usr/portage/eclass/python-utils-r1.eclass
# (verified at line 41) only knows python3_{12..15}, so python3_11 is not a
# valid PYTHON_COMPAT entry on this machine and PYTHON_COMPAT_NO_STRICT=1
# does NOT bypass the "No supported implementation" die at
# python-utils-r1.eclass:168.
#
# We are therefore forced to declare PYTHON_COMPAT=( python3_{12..15} ) so
# the eclass accepts the ebuild at all. Caveat: podly's own requires-python
# check will reject the install at runtime (pip will refuse to resolve a
# wheel on 3.12+ against ">=3.11,<3.12").
#
# Resolution requires either:
#   1. Installing python3_11 system-wide so the host eclass is updated /
#      a binary is available, OR
#   2. Upstream widening its Python support to include 3.12+.
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Self-hosted ad-free podcast RSS feed generator with LLM-based ad detection"
HOMEPAGE="https://github.com/podly-pure-podcasts/podly_pure_podcasts"
SRC_URI="https://github.com/podly-pure-podcasts/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN//_/-}-${PV}"

# Upstream ships the licence as LICENCE (british spelling); setuptools
# picks it up automatically but distutils-r1 expects lowercase LICENSE.
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-lang/python-3.12
	>=dev-python/flask-3.1.2[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.1.6[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-3.1.5[${PYTHON_USEDEP}]
	>=dev-python/flask-sqlalchemy-3.1.1[${PYTHON_USEDEP}]
	>=dev-python/flask-migrate-4.1.0[${PYTHON_USEDEP}]
	>=dev-python/flask-cors-6.0.2[${PYTHON_USEDEP}]
	>=dev-python/flask-apscheduler-1.13.1[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-2.0.46[${PYTHON_USEDEP}]
	>=dev-python/alembic-1.18.4[${PYTHON_USEDEP}]
	>=dev-python/apscheduler-3.11.2[${PYTHON_USEDEP}]
	>=dev-python/waitress-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/openai-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/groq-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/litellm-1.81.11[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/httpx-aiohttp-0.1.12[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-3.13.3[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.12.5[${PYTHON_USEDEP}]
	>=dev-python/pydantic-core-2.41.5[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.3[${PYTHON_USEDEP}]
	>=dev-python/feedparser-6.0.12[${PYTHON_USEDEP}]
	>=dev-python/pyrss2gen-1.1[${PYTHON_USEDEP}]
	>=dev-python/pypodcastparser-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/mutagen-1.47.0[${PYTHON_USEDEP}]
	>=dev-python/speechrecognition-3.14.5[${PYTHON_USEDEP}]
	>=dev-python/bleach-6.3.0[${PYTHON_USEDEP}]
	>=dev-python/validators-0.35.0[${PYTHON_USEDEP}]
	>=dev-python/beartype-0.22.9[${PYTHON_USEDEP}]
	>=dev-python/zeroconf-0.148.0[${PYTHON_USEDEP}]
	>=dev-python/ffmpeg-python-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/stripe-14.3.0[${PYTHON_USEDEP}]
	>=dev-python/bcrypt-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/certifi-2026.1.4[${PYTHON_USEDEP}]
	acct-user/podly_pure_podcasts
	acct-group/podly_pure_podcasts
	media-video/ffmpeg
"

DEPEND="${RDEPEND}"

BDEPEND="
	>=net-libs/nodejs-20[npm]
"

src_compile() {
	# 1. Build the React/Vite frontend; output lands in frontend/dist.
	pushd frontend > /dev/null || die
	npm ci || die "npm ci failed"
	npm run build || die "vite build failed"
	popd > /dev/null || die

	# 2. Build the Python package (setuptools).
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install

	# Drop the built frontend assets into the Flask app's static dir so
	# the bundled JS/CSS is served by waitress.
	if [[ -d "${S}/frontend/dist" ]]; then
		insinto "/usr/lib/${PN}/src/app/static"
		doins -r "${S}/frontend/dist/"*
	fi

	newinitd "${FILESDIR}/${PN}.initd" "${PN}" || die
	newconfd "${FILESDIR}/${PN}.confd" "${PN}" || die

	keepdir "/var/log/${PN}"
	keepdir "/var/lib/${PN}"
}
