## Existing context (vault)

- `Projects/haven-overlay/findings.md` (2026-09-02): "DISTUTILS_USE_PEP517
  backend drift across 11 packages (47 ebuilds)" — full audit; 11 packages
  had ebuilds whose declared DISTUTILS_USE_PEP517 no longer matched
  upstream pyproject.toml's `build-backend`. Per-package fix commits
  pushed 2026-09-02; same session surfaced a follow-up anti-pattern
  ("never assume sibling versions share a build backend — face-26.0.0
  uses setuptools.build_meta, face-26.0.1 uses flit_core.buildapi").
- `Projects/haven-overlay/findings.md` (2026-08-29, openspec
  fix-ebuild-bump-failures): bump stage fails silently when SRC_URI points
  at non-existent artefacts. Pre-existing precedent for "bump can't catch
  upstream drift" — same root cause family as this proposal.
- `Projects/haven-overlay/findings.md` (2026-08-04): "fix newest ebuild
  first — bump engine propagates" — ebuild-updater copies the LATEST
  ebuild as the new-version template. The current defect class emerges
  from this: the LATEST ebuild is taken as gospel even when the upstream
  tarball has a different build-backend than the previous version.

## Hypothesis

`ebuild-updater cleanup scan` covers `missing-manifest` and
`broken-maturin-ebuild` categories but does NOT include a
`wrong-pep517-backend` category. The defect class is invisible to the
daily pipeline; it surfaces only when an operator runs `emerge` on an
affected package and hits the distutils-r1 gate:

```
* DISTUTILS_UPSTREAM_PEP517 does not match pyproject.toml!
*   DISTUTILS_UPSTREAM_PEP517=setuptools
*   implies backend: setuptools.build_meta
*    pyproject.toml: flit_core.buildapi
* ERROR: dev-python/<pkg>-<ver>::haven-overlay failed (compile phase):
*   DISTUTILS_USE_PEP517 value incorrect
```

Fix is trivial (one-line `DISTUTILS_USE_PEP517=...` change; the eclass
auto-adds the right BDEPEND), but the discovery is manual.

## Evidence

**Audit results, 2026-09-02.** Script:
`/tmp/opencode/pep517-audit/audit.py`. Scans every `dev-python/*/*.ebuild`
that sets `DISTUTILS_USE_PEP517`, extracts `pyproject.toml` from the
tarball in `/usr/portage-distfiles/`, reads `build-backend`, compares
against the ebuild's value via the canonical skill mapping:

| upstream build-backend | canonical DISTUTILS_USE_PEP517 |
|---|---|
| `setuptools.build_meta` | `setuptools` |
| `hatchling.build` | `hatchling` |
| `flit_core.buildapi` | `flit` |
| `poetry.core.masonry.api` | `poetry` |
| `pdm.backend` | `pdm-backend` |
| `maturin` | `maturin` |
| `uv_build` | `uv-build` |
| `mesonpy` | `meson-python` |

**Scope**: 919 dev-python ebuilds scanned; 400 had `pyproject.toml`
cached locally; **47 mismatches across 11 packages**.

**Per-package breakdown**:

| package | versions mismatched | current → should-be |
|---|---|---|
| b2sdk | 2.10.4, 2.12.0 | pdm-backend → hatchling |
| copier | 9.15.0 | setuptools → hatchling |
| face | 26.0.1 | setuptools → flit |
| httpx-retries | 0.5.0 | setuptools → hatchling |
| langfuse | 10 ebuilds 4.13.1–4.15.1 | setuptools → uv-build |
| litellm | 10 ebuilds 1.92.0–1.99.0 | poetry → maturin |
| pagerduty | 4 ebuilds 6.2.1–7.0.0 | hatchling → uv-build (with sed workaround) |
| phx-class-registry | 5.1.1, 5.2.1, 5.2.2 | per-version (poetry / hatchling) |
| pyacoustid | 1.3.1 | setuptools → poetry |
| solana | 7 ebuilds 0.37.1–0.40.3 | poetry → hatchling |
| stripe | 7 ebuilds 14.3.0–15.6.1 | setuptools → flit |

Total: **47 ebuilds**. All fixed in 11 per-package commits, validated
via `ebuild clean install`, pushed 2026-09-02.

**Coverage gap**: the audit skipped 554 ebuilds whose tarballs were
not in `/usr/portage-distfiles/` on this host. Many of those tarballs
have never been fetched (e.g. the nightly bumps commit without
`ebuild manifest`). Re-audit after running `emaint sync -r
haven-overlay` + `egencache --repo=haven-overlay --update` to populate
the cache.

## Root cause analysis

`ebuild manifest` succeeds because it only downloads the SRC_URI
artefacts listed in the ebuild — it does NOT inspect the resulting
tarball for upstream metadata that conflicts with the ebuild's
declared variables. Once the manifest is committed, the bump stage
rolls forward; the distutils-r1 gate fires only at `emerge` time on
a target host.

`ebuild-updater cleanup scan` reads ebuilds and looks for known
broken patterns but does not currently include a category that
extracts tarballs (or pyproject.toml from them) and cross-checks
upstream metadata. Adding `wrong-pep517-backend` would close this
gap.

**Blast radius if untreated**:
- Any operator that runs `emerge` on an affected package dies in
  `src_compile`. They file a bug, an agent fixes it; meanwhile
  every other operator hits the same dead end.
- For new-version bumps (the common case), the mismatch is silently
  propagated via the latest-ebuild template for every future bump of
  the same package, until someone notices.
- For existing-version bumps (rare), the older version with the
  stale value may also be broken if the upstream tarball changed
  retroactively (uncommon but possible — pyacoustid 1.3.1 added
  pyproject.toml where 1.3.0 had only setup.py).

## Direction

Add a `wrong-pep517-backend` category to `ebuild-updater cleanup
scan` (and to any future `cleanup run --repair` automation):

1. **Discover**: For every ebuild that sets `DISTUTILS_USE_PEP517=`,
   locate the matching tarball in `/usr/portage-distfiles/`
   (`<pkg>-<ver>.<ext>`). If absent, skip with a "no distfile"
   marker (same as today's `missing-manifest` behaviour).
2. **Extract**: Read `pyproject.toml` from the tarball, prefer the
   top-level member (`<pkg>-<ver>/pyproject.toml`).
3. **Compare**: `build-backend` → canonical DISTUTILS_USE_PEP517 via
   the table above.
4. **Report**: If the canonical value differs from the ebuild's
   declared value, emit a `wrong-pep517-backend:<ebuild>` line with
   `current=<X> upstream_backend=<Y> should_be=<Z>`.
5. **(Optional) Repair**: `cleanup run --repair` rewrites
   `DISTUTILS_USE_PEP517=` to the canonical value (one-line sed,
   verified against the audit pattern).

The same script (`/tmp/opencode/pep517-audit/audit.py`) is the
reference implementation; it already does steps 1–4. A pytest in
`scripts/tests/test_pep517_backend_drift.py` would be the regression
test fixture for the new scanner, modeled on the existing
`test_src_uri_fetchable.py` from the fix-ebuild-bump-failures change.