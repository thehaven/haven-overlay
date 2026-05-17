# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="Data Version Control - ML experiment management"
HOMEPAGE="https://dvc.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+dag"

RDEPEND="
	dev-python/attrs
	dev-python/celery
	dev-python/colorama
	dev-python/configobj
	dev-python/distro
	dev-python/dpath
	dev-python/dulwich
	dev-python/dvc-data
	dev-python/dvc-http
	dev-python/dvc-objects
	dev-python/dvc-render
	dev-python/dvc-studio-client
	dev-python/dvc-task
	dev-python/flatten-dict
	dev-python/flufl_lock
	dev-python/fsspec
	dev-python/funcy
	dev-python/grandalf
	dev-python/gto
	dev-python/hydra-core
	dev-python/iterative-telemetry
	dev-python/kombu
	dev-python/networkx
	dev-python/omegaconf
	dev-python/packaging
	dev-python/pathspec
	dev-python/platformdirs
	dev-python/psutil
	dag? ( dev-python/pydot )
	dev-python/pygtrie
	dev-python/pyparsing
	dev-python/requests
	dev-python/rich
	dev-python/ruamel_yaml
	dev-python/scmrepo
	dev-python/shortuuid
	dev-python/shtab
	dev-python/tabulate
	dev-python/tomlkit
	dev-python/tqdm
	dev-python/voluptuous
	dev-python/zc_lockfile
"
