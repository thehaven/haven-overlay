# gentoo-ebuild cheatsheet

The minimum an agent needs to write, maintain, and debug ebuilds in this
overlay. Self-contained — every command, rule, and lookup table in this
file works without any external tool or installed skill.

## Overlay layout

```
my-overlay/
├── metadata/
│   └── layout.conf          # masters = gentoo
├── profiles/
│   ├── repo_name            # overlay name
│   └── categories           # custom categories only
├── eclass/                  # custom eclasses
├── category/
│   └── package/
│       ├── package-1.0.ebuild
│       ├── metadata.xml
│       └── Manifest
```

`metadata/layout.conf` for this overlay:

```
masters = gentoo
auto-sync = false
thin-manifests = true
sign-manifests = false
```

Only add custom categories to `profiles/categories`. Standard Gentoo
categories are inherited from the master automatically.

## Permissions

When working under `/var/db/repos/`, prefix commands with `sudo` unless
you are in the `portage` group. On most systems, `/var/db/repos/` is
owned by `root:root`. The `edit` and `write` tools cannot touch
portage-owned files; use `sudo -n tee …`, `sudo -n sed -i …`, or
`sudo -n python3 -c …` for those. After every write, restore ownership
with `sudo -n chown -R portage:portage <path>`.

## Manifest generation

```bash
# In the package directory:
sudo -n ebuild <cat>/<pkg>/<ebuild> manifest

# Or use pkgcheck:
sudo -n pkgcheck scan --manifest
```

## `emerge` shell quoting — MANDATORY for `=` atom prefix

The `=` in `=category/package-version` is interpreted by `zsh` (and
sometimes `bash`). Always single-quote the atom:

```bash
# Right
emerge -1 '=dev-python/jiter-0.16.0'

# Wrong — zsh tries to evaluate "0.16.0" as a glob or command
emerge -1 =dev-python/jiter-0.16.0
```

This applies to every emerge flag combination: `--ask`, `-1`,
`--oneshot`, `-C`, etc.

## Common portage failures

| Symptom | Root cause | Fix |
|---|---|---|
| `Permission denied` on `ebuild`/write | Overlay under `/var/db/repos/` owned by `root:root` | `sudo`, or join `portage` group |
| `ebuild manifest` fails | SRC_URI wrong, distfiles unreachable | Verify each URL, regenerate Manifest |
| `go mod: network required` | Build fetches Go modules at compile | Add vendor tarball, or `RESTRICT="network-sandbox"` (note: this *allows* network for the build — it disables the default sandbox, it does not block anything) |
| `QA Notice: EGO_SUM is deprecated` | Old Go ebuild pattern | Migrate to vendor tarball approach |
| `file collision` | Two packages install the same path | Check `SLOT`; add `RDEPEND` blocker |
| `sandbox violation` | Code writes outside `${D}` | Fix install paths |
| `DISTUTILS_UPSTREAM_PEP517 does not match pyproject.toml` | Wrong `DISTUTILS_USE_PEP517` | Read tarball's `pyproject.toml` `[build-system] build-backend`; match it exactly |
| `npm ERR! code E404` during install | SRC_URI tarball name wrong | For scoped `@scope/name`, the filename is the last component only |
| npm package extracts to wrong directory | npm tarballs always unpack to `package/` | Set `S="${WORKDIR}/package"` |
| `SRC_URI ${P}.tgz doesn't match npm tarball name` | PN differs from npm registry name | Use arrow rename: `-> ${P}.tgz`; verify with `curl -s https://registry.npmjs.org/<pkg>/<version> \| jq .dist.tarball` |
| `pypi fetch fails with wrong filename` | PN differs from PyPI project name | Set `PYPI_PN="actual-pypi-name"` BEFORE `inherit pypi` |
| `zsh:1: <atom> not found` after emerge | `=` in atom is being interpreted by the shell | Wrap in single quotes: `emerge -1 '=category/package-version'` |

## npm registry version verification

Research docs and community references frequently list stale versions.
Always verify before writing `PV`:

```bash
npm view <pkg> version
# or
curl -s https://registry.npmjs.org/<pkg>/latest | jq .version
```

## Python: `DISTUTILS_USE_PEP517` mapping

`DISTUTILS_USE_PEP517` must match `pyproject.toml` `[build-system]
build-backend` exactly. Never guess.

| `pyproject.toml` build-backend | `DISTUTILS_USE_PEP517` | Extra BDEPEND |
|---|---|---|
| `poetry.core.masonry.api` | `poetry` | `dev-python/poetry-core` |
| `hatchling.build` | `hatchling` | — (provided by eclass) |
| `setuptools.build_meta` | `setuptools` | — (provided by eclass) |
| `flit_core.buildapi` | `flit` | `dev-python/flit-core` |
| `pdm.backend` | `pdm` | `dev-python/pdm` |
| `maturin` | `maturin` | `dev-util/maturin` |

