# haven-overlay

A personal Gentoo **layman overlay** for Simon Alman.

- Browse: [`https://gitlab-ee.thehavennet.org.uk/gentoo/haven-overlay`](https://gitlab-ee.thehavennet.org.uk/gentoo/haven-overlay).
- Mirror: [`https://github.com/thehaven/haven-overlay`](https://github.com/thehaven/haven-overlay)
- Default branch: [`master`](https://gitlab-ee.thehavennet.org.uk/gentoo/haven-overlay/-/tree/master) (commits land directly; no PRs)
- License: [GNU Affero GPL v3](LICENSE)

This overlay contains custom ebuilds, a handful of local eclasses, and
repo-level config for [`ebuild-updater`](https://gitlab-ee.thehavennet.org.uk/gentoo/ebuild-updater) and per-package bump/discover
hooks. Many ebuilds are copied, borrowed, or edited versions of those in
other layman repos — kept current for personal use, particularly where a
version bump hadn't reached the mainstream repo yet.

## Working in this overlay

Start with **[AGENTS.md](AGENTS.md)** — it documents the overlay's
mandatory working rules (sudo, ownership, portage-owned files), how the
overlay is laid out (profiles, eclasses, scripts), the strict source-based
Node.js/Bun policy, the `ebuild-updater` integration, and the verified
gotchas an agent would otherwise hit. For general ebuild conventions (EAPI, KEYWORDS, QA flags, manifest commands, Go/Rust/Binary patterns), see [`docs/gentoo-ebuild-cheatsheet.md`](docs/gentoo-ebuild-cheatsheet.md).

## Repo at a glance

| | |
| --- | --- |
| Ebuilds | ~2,450 |
| Categories claimed | 57 (see [`profiles/categories`](profiles/categories)) |
| Local eclasses | `bun`, `npm`, `go-module-offline`, plus Go/Lua/eutils extensions — see [`eclass/`](eclass/) |
| Helper scripts | [`scripts/npm2ebuild.py`](scripts/npm2ebuild.py), [`scripts/verify-mcp.sh`](scripts/verify-mcp.sh), [`scripts/verify-npm-bin.sh`](scripts/verify-npm-bin.sh) |
| Tests | [`scripts/tests/test_{grafonnet,headroom_ai,litellm}_ebuild.py`](scripts/tests/) (`pytest scripts/tests/`) |
| Operator config | [`ebuild-updater.toml`](ebuild-updater.toml) (hold list, repo path) |
| Layman metadata | [`haven-overlay.xml`](haven-overlay.xml) |

## Categories — what's here

The full list lives in [`profiles/categories`](profiles/categories). Most
follow stock Gentoo; the overlay also claims three categories that are
not in the main tree ([`dev-nodejs`](dev-nodejs/), [`www-nginx`](profiles/categories), [`www-servers`](profiles/categories)) and one
overlay-local category ([`app-vuln`](app-vuln/)).

The heaviest packages, by ebuild count:

| Category | Ebuilds | Notes |
| --- | ---: | --- |
| [`dev-python`](dev-python/) | ~770 | Python tooling, ML client libs |
| [`dev-util`](dev-util/) | ~470 | MCP servers (`mcp-meta` virtual), LSP servers, CLI tools |
| [`app-misc`](app-misc/) | ~350 | Personal utilities |
| [`app-admin`](app-admin/) | ~140 | Argo CD/Workflows/Rollouts/Events CLI suite, [`app-admin/harbor`](app-admin/harbor/) (meta) |
| [`acct-user`](acct-user/) / [`acct-group`](acct-group/) | ~70 each | Service-account definitions |
| [`net-nntp`](net-nntp/) | ~55 | Sonarr, SABnzbd, NZBGet |
| [`net-im`](net-im/) | ~35 | Synapse, Element |
| [`www-apps`](www-apps/) | ~35 | Audiobookshelf, readmeabook |
| [`dev-ml`](dev-ml/) | ~25 | litellm (CRATES regenerator lives at [`net-im/synapse/update_ebuild.py`](net-im/synapse/update_ebuild.py)) |
| [`sys-cluster`](sys-cluster/) | ~45 | Kubernetes, Argo |

Counts are an approximate snapshot. Run
`find /var/db/repos/haven-overlay -name '*.ebuild' | wc -l` for the
current total.

## Maintenance scripts

```bash
# Audit every inherit-npm ebuild for missing /usr/bin symlinks
sudo /var/db/repos/haven-overlay/scripts/verify-npm-bin.sh

# Smoke test MCP binaries after a packaging change
sudo /var/db/repos/haven-overlay/scripts/verify-mcp.sh

# Generate a source-based ebuild for an npm registry package
python3 /var/db/repos/haven-overlay/scripts/npm2ebuild.py --package <name>@<ver>

# Run ebuild metadata tests
pytest /var/db/repos/haven-overlay/scripts/tests/
```

## Dead / unreachable upstream

[`profiles/package.mask`](profiles/package.mask) lists packages whose source tarballs are no
longer reachable. Add to it rather than deleting the ebuild, so
`ebuild-updater` stops trying to refresh them.

## Out of scope

Planning, design, and ADR-style decisions don't belong in this repo.
Skills and tooling live in a separate, private repository.
