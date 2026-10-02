## Task 1.1 — skillspector ebuild: IUSE=mcp + pinned dep + pkg_postinst

**Goal**: `skillspector mcp` works on a clean system and users get
provider configuration guidance at install time.
**Files**: `app-vuln/skillspector/skillspector-2.11.2.ebuild`
**Steps**:
1. Add `IUSE="mcp"` after KEYWORDS.
2. Add to RDEPEND (with comment explaining the mcp 2.x FastMCP
   removal and the missing 1.29.x):
   ```
   mcp? (
       >=dev-python/mcp-1.28.1[${PYTHON_USEDEP}]
       <dev-python/mcp-2[${PYTHON_USEDEP}]
   )
   ```
3. Add `pkg_postinst()` with elog lines: static-only default, env-var
   config, upstream `.env.example` URL, Ollama/LiteLLM/OpenRouter
   recipes, `skillspector mcp` subcommand note, structured-output
   caveat for local models.
**Verify**: `sudo ebuild skillspector-2.11.2.ebuild manifest` exits 0;
`sudo ebuild skillspector-2.11.2.ebuild clean install` exits 0;
`USE=mcp emerge --pretend '=app-vuln/skillspector-2.11.2'` resolves
mcp-1.28.1 (not 2.x).
**Commit**: `app-vuln/skillspector: add mcp USE flag and post-install provider guidance`

---

## Task 1.2 — skillspector metadata.xml use flag

**Goal**: `equery u skillspector` / `euse -i mcp` shows a description.
**Files**: `app-vuln/skillspector/metadata.xml`
**Steps**:
1. Insert `<use><flag name="mcp">Install the MCP server extra
   (skillspector mcp subcommand)</flag></use>` after the maintainer
   block, preserving the existing maintainer email.
**Verify**: `xmllint --noout metadata.xml` exits 0.
**Commit**: (folded into Task 1.1 commit)

---

## Task 1.3 — stele mcp dep pin (3 ebuilds)

**Goal**: stele's mcp mode survives an mcp 2.x install.
**Files**: `app-admin/stele/stele-0.4.1_pre.ebuild`,
`app-admin/stele/stele-0.4.4.ebuild`, `app-admin/stele/stele-9999.ebuild`
**Steps**:
1. Replace `mcp? ( dev-python/mcp[${PYTHON_USEDEP}] )` with the pinned
   `>=1.28.1 <2` block plus a one-line comment.
**Verify**: `grep -n "dev-python/mcp" app-admin/stele/*.ebuild` shows
the pin in all three; `emerge --pretend '=app-admin/stele-0.4.4'` with
USE=mcp resolves mcp-1.28.1.
**Commit**: `app-admin/stele: pin mcp dep below 2 (FastMCP removed in mcp 2.x)`

---

## Task 1.4 — mcp-meta 5.6.8: add skillspector/stele/librenms flags

**Goal**: the meta-package can pull in all three MCP-capable packages
with the MCP capability forced.
**Files**: `dev-util/mcp-meta/mcp-meta-5.6.8.ebuild` (new)
**Steps**:
1. Copy 5.6.7; add `librenms`, `skillspector`, `stele` to IUSE
   (alphabetical: librenms after linkedin; skillspector after
   sequential-thinking; stele after slack).
2. Add RDEPEND lines:
   ```
   librenms? ( dev-python/clr-librenms-mcp )
   skillspector? ( app-vuln/skillspector[mcp] )
   stele? ( app-admin/stele[mcp] )
   ```
   Use-deps force the MCP capability so the flag actually delivers an
   MCP server.
**Verify**: `emerge --pretend '=dev-util/mcp-meta-5.6.8'` with
`USE="skillspector stele librenms"` resolves all three packages.
**Commit**: `dev-util/mcp-meta: bump to 5.6.8; add skillspector, stele, librenms MCP servers`

---

## Task 1.5 — use.local.desc drift fix

**Goal**: every mcp-meta flag has a description; stale entries removed.
**Files**: `profiles/use.local.desc`
**Steps**:
1. Add 17 missing entries (composio, cortex, filesystem, forge,
   gemini-deepsearch, github-mcp-server, headroom, linkedin, mesh,
   paperclip, perplexity-ask, perplexity-community, plur, postgres,
   slack, terraform, time) and 3 new ones (librenms, skillspector,
   stele), keeping the file alphabetised.
2. Remove the stale `dev-util/mcp-meta:atlassian` line.
**Verify**: every flag in mcp-meta-5.6.8 IUSE has a
`dev-util/mcp-meta:<flag>` line; no line references a flag not in IUSE.
**Commit**: `profiles: sync use.local.desc with mcp-meta flags (20 added, 1 removed)`

---

## Task 1.6 — verify-mcp.sh binaries

**Goal**: the smoke-test runner covers the three new MCP binaries.
**Files**: `scripts/verify-mcp.sh`
**Steps**:
1. Add `/usr/bin/clr-librenms-mcp`, `/usr/bin/skillspector`,
   `/usr/bin/stele-mcp` to BINARIES (script skips absent binaries).
**Verify**: `sudo scripts/verify-mcp.sh` exits 0 (skillspector/stele-mcp
installed; clr-librenms-mcp installed).
**Commit**: `scripts: add skillspector, stele-mcp, clr-librenms-mcp to verify-mcp.sh`

---

## Task 1.7 — Validation

**Goal**: all changes pass the overlay's validation gates.
**Files**: none (verification only)
**Steps**:
1. `sudo ebuild app-vuln/skillspector/skillspector-2.11.2.ebuild manifest`
2. `sudo ebuild app-vuln/skillspector/skillspector-2.11.2.ebuild clean install`
3. `emerge --pretend '=dev-util/mcp-meta-5.6.8'` with the three new flags
4. `openspec validate --all`
5. `pytest scripts/tests/`
6. `sudo scripts/verify-mcp.sh`
**Verify**: all six gates pass. Note: pkgcheck is broken on this host
(Python 3.14 TypeError in pkgcheck/checks/python.py) — record as known
limitation, do not block on it.
**Commit**: (no commit — verification only)
