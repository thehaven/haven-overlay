# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Asynchronous Python Telegram Bot API client library"
HOMEPAGE="
	https://python-telegram-bot.org
	https://github.com/python-telegram-bot/python-telegram-bot
	https://pypi.org/project/python-telegram-bot/
"
SRC_URI="https://files.pythonhosted.org/packages/source/p/python-telegram-bot/python_telegram_bot-${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/python_telegram_bot-${PV}"

# Dual-licensed: LGPL-3.0-only OR GPL-2.0-or-later (see LICENSE.dual).
LICENSE="LGPL-3 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	<dev-python/httpx-0.29[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27[${PYTHON_USEDEP}]
"

# Optional extras from pyproject.toml — optfeature in pkg_postinst.
# - ext: aiolimiter, apscheduler, cachetools, tornado
# - http2: httpx[http2]
# - socks: httpx[socks]
# - job-queue: apscheduler
# - webhooks: tornado
# - passport: cffi, cryptography
# - callback-data: cachetools
# - rate-limiter: aiolimiter
# - all: all of the above
pkg_postinst() {
	optfeature "ext (webhooks, job-queue, etc.)" \
		"dev-python/aiolimiter dev-python/apscheduler dev-python/cachetools dev-python/tornado"
	optfeature "HTTP/2 support"           ">=dev-python/httpx-0.27.0[http2] dev-python/h2"
	optfeature "SOCKS proxy support"       ">=dev-python/httpx-0.27.0[socks] dev-python/socksio"
	optfeature "Telegram Passport (MTProto)" 		"dev-python/cffi >=dev-python/cryptography-39.0.1"
}
