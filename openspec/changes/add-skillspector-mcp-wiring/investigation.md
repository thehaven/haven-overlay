## Existing context (vault)

- `Projects/haven-overlay/findings.md` (2026-09-16): SkillSpector
  packaging review — `app-vuln/skillspector-2.11.2` ships no
  `pkg_postinst`, no `IUSE`, and the `skillspector mcp` subcommand
  (upstream extra `mcp>=1.29,<2.0`) is unreachable on a clean system.
  The tool's own error message tells users to `pip install
  'skillspector[mcp]'`, which is wrong advice on Gentoo.
- Same session: mcp-meta audit — `dev-util/mcp-meta` (5.6.7) is missing
  three MCP-capable packages (skillspector, stele, clr-librenms-mcp),
  and `profiles/use.local.desc` has 17 flags without descriptions plus
  one stale entry (`atlassian`).
- Same session: mcp-2.x FastMCP landmine — mcp 2.x removed
  `mcp.server.fastmcp` (shim raises ModuleNotFoundError); the overlay
  ships mcp 1.27.0–1.28.1 and 2.0.0–2.2.0 but no 1.29.x. Unpinned
  `dev-python/mcp` deps (semgrep ×10, ai-compressor, anthropic extra,
  stele ×3) resolve to 2.2.0 on fresh installs and break at import.

## Hypothesis

`app-vuln/skillspector` is not properly set up by default: the MCP
extra is not wired into the ebuild, the mcp dependency is unpinned
against the 2.x FastMCP removal, and users receive no post-install
guidance on configuring an LLM provider (the semantic analyzers are
silently skipped without one). The same unpinned-mcp defect affects
`app-admin/stele` (3 ebuilds). `dev-util/mcp-meta` should pull in all
three MCP-capable packages with use-deps that force the MCP capability.

## Evidence

- `skillspector mcp` requires the `mcp` extra (`mcp>=1.29.0,<2.0.0` in
  pyproject.toml `[project.optional-dependencies]`); `mcp_server.py`
  imports `mcp.server.fastmcp` lazily and raises ModuleNotFoundError
  with pip advice when absent. Verified: `build_server()` succeeds with
  mcp-1.28.1 (Python 3.14.7); mcp-2.2.0's `fastmcp.py` is a 16-line
  shim that raises.
- Overlay ships mcp 1.27.0–1.28.1 + 2.0.0–2.2.0; no 1.29.x, so
  upstream's `>=1.29,<2.0` pin is unsatisfiable. Correct bound:
  `>=dev-python/mcp-1.28.1 <dev-python/mcp-2` (house precedent:
  `dev-python/mcp-server-time-2026.8.18` pins `>=1.28.1 <3` with an
  mcp2-compat patch; packages without a compat patch need `<2`).
- `stele` (app-admin, 3 ebuilds: 0.4.1_pre, 0.4.4, 9999) declares
  `mcp? ( dev-python/mcp[${PYTHON_USEDEP}] )` unpinned; installed
  source imports `mcp.server.fastmcp` (stele/mcp/server.py + tools/*.py).
- `dev-python/clr-librenms-mcp` is fastmcp-based
  (`>=dev-python/fastmcp-3.4.2`), no IUSE, bin `/usr/bin/clr-librenms-mcp`.
- mcp-meta 5.6.7 IUSE/RDEPEND has no skillspector/stele/librenms flags;
  bump convention is one version per flag addition (5.6.2 → 5.6.7).
- use.local.desc: 17 mcp-meta flags lack entries (composio, cortex,
  filesystem, forge, gemini-deepsearch, github-mcp-server, headroom,
  linkedin, mesh, paperclip, perplexity-ask, perplexity-community,
  plur, postgres, slack, terraform, time); `atlassian` entry is stale
  (no ebuild references it).
- Precommit gate (gentoo-ebuild skill, item 8): MCP-server-capable
  packages must ship `pkg_postinst()` with configuration snippets.
  Every sibling app-vuln package has one; skillspector is the only one
  without.
- Provider config is env-var only (no config file): `SKILLSPECTOR_PROVIDER`
  selects openai/anthropic/anthropic_proxy/bedrock/nv_build/ollama/
  azure_openai/openai_compatible/claude_cli/codex_cli/gemini_cli;
  default is nv_build (needs NVIDIA_INFERENCE_KEY) — hence the three
  "Skipping analyzer" warnings on every invocation without credentials.

## Root cause analysis

The ebuild was written to the base package only: the optional MCP extra
was not exposed as a USE flag, the mcp dependency was not pinned against
the 2.x FastMCP removal (which the overlay's mcp 2.0.0–2.2.0 ebuilds
make the default resolution), and no `pkg_postinst` was added despite
the repo's own precommit gate requiring one for MCP-capable packages.
The mcp-meta gap is a completeness issue: three MCP-capable packages
were never added to the meta-package, and use.local.desc drifted as
flags were added without descriptions.

**Blast radius if untreated**:
- `skillspector mcp` dies with ModuleNotFoundError on any clean system;
  the pip advice in the error is wrong on Gentoo.
- Any unpinned `dev-python/mcp` consumer (stele, semgrep, ai-compressor,
  anthropic extra) breaks at import once mcp 2.x is installed.
- Users get no guidance on enabling semantic analysis; the default
  nv_build provider requires an NVIDIA key nobody on this host has.

## Direction

1. `app-vuln/skillspector`: add `IUSE="mcp"` with
   `mcp? ( >=dev-python/mcp-1.28.1[${PYTHON_USEDEP}] <dev-python/mcp-2[${PYTHON_USEDEP}] )`
   and a `pkg_postinst()` documenting provider env recipes (Ollama,
   LiteLLM via openai+base-url, OpenRouter), the `skillspector mcp`
   subcommand, the upstream `.env.example` reference, and the
   structured-output caveat for local models.
2. `app-vuln/skillspector/metadata.xml`: add `<use><flag name="mcp">`.
3. `app-admin/stele` (3 ebuilds): pin the mcp dep to the same
   `>=1.28.1 <2` bound.
4. `dev-util/mcp-meta` 5.6.8: add `skillspector`/`stele`/`librenms`
   flags with use-deps forcing the MCP capability
   (`app-vuln/skillspector[mcp]`, `app-admin/stele[mcp]`,
   `dev-python/clr-librenms-mcp`).
5. `profiles/use.local.desc`: add the 17 missing + 3 new entries,
   remove the stale `atlassian` line.
6. `scripts/verify-mcp.sh`: add `/usr/bin/skillspector`,
   `/usr/bin/stele-mcp`, `/usr/bin/clr-librenms-mcp` to BINARIES.
7. Validation: `ebuild manifest` + `clean install` for skillspector,
   `emerge --pretend` for mcp-meta 5.6.8 with the new flags,
   `openspec validate --all`, `pytest scripts/tests/`,
   `sudo scripts/verify-mcp.sh`.
