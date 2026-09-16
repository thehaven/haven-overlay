## Task 1.1 — semgrep mcp dep pin (10 ebuilds)

**Goal**: semgrep's MCP server survives an mcp 2.x install.
**Files**: `app-vuln/semgrep/semgrep-{1.168.0..1.177.0}.ebuild`
**Steps**:
1. Replace `dev-python/mcp[${PYTHON_USEDEP}]` with:
   ```
   >=dev-python/mcp-1.28.1[${PYTHON_USEDEP}]
   <dev-python/mcp-2[${PYTHON_USEDEP}]
   ```
   plus a one-line comment ABOVE the RDEPEND string (mcp 2.x removed
   `mcp.server.fastmcp`; semgrep imports it in commands/mcp.py +
   mcp/server.py).
**Verify**: `grep -n "dev-python/mcp" app-vuln/semgrep/*.ebuild` shows
the pin in all 10; `emerge --pretend '=app-vuln/semgrep-1.177.0'`
resolves mcp-1.28.1.
**Commit**: `app-vuln/semgrep: pin mcp dep below 2 (FastMCP removed in mcp 2.x)`

---

## Task 1.2 — ebuild-updater mcp dep pin (11 ebuilds)

**Goal**: ebuild-updater's mcp mode survives an mcp 2.x install.
**Files**: `dev-util/ebuild-updater/ebuild-updater-{2.8.2..2.10.6,9999}.ebuild`
**Steps**:
1. Replace `mcp? ( dev-python/mcp[${PYTHON_USEDEP}] )` with the pinned
   `>=1.28.1 <2` block plus a one-line comment above the RDEPEND string.
**Verify**: `grep -n "dev-python/mcp" dev-util/ebuild-updater/*.ebuild`
shows the pin in all 11; `emerge --pretend '=dev-util/ebuild-updater-2.10.6'`
with USE=mcp resolves mcp-1.28.1.
**Commit**: `dev-util/ebuild-updater: pin mcp dep below 2 (FastMCP removed in mcp 2.x)`

---

## Task 1.3 — x402 + mcp-pagerduty mcp dep pin (11 ebuilds)

**Goal**: x402 and mcp-pagerduty MCP servers survive an mcp 2.x install.
**Files**: `dev-python/x402/x402-{2.14.0..2.23.0}.ebuild` (10),
`dev-util/mcp-pagerduty/mcp-pagerduty-0.17.0.ebuild` (1)
**Steps**:
1. Replace `dev-python/mcp[${PYTHON_USEDEP}]` with the pinned
   `>=1.28.1 <2` block plus a one-line comment above the RDEPEND string
   (x402: mcp/server.py imports FastMCP + Context; mcp-pagerduty:
   pagerduty_mcp/server.py imports FastMCP).
**Verify**: `grep -n "dev-python/mcp" dev-python/x402/*.ebuild
dev-util/mcp-pagerduty/*.ebuild` shows the pin in all 11;
`emerge --pretend '=dev-python/x402-2.23.0'` resolves mcp-1.28.1.
**Commit**: `dev-python/x402, dev-util/mcp-pagerduty: pin mcp dep below 2 (FastMCP removed in mcp 2.x)`

---

## Task 1.4 — mcp-alertmanager verification + pin

**Goal**: determine whether mcp-alertmanager imports fastmcp; pin if so.
**Files**: `dev-util/mcp-alertmanager/mcp-alertmanager-{1.1.0,1.2.0}.ebuild`
**Steps**:
1. Fetch the 1.2.0 distfile (`sudo ebuild ... fetch` or curl) and grep
   the source for `fastmcp` / `mcp.server`.
2. If it imports fastmcp: pin `>=1.28.1 <2` as in Tasks 1.1–1.3.
3. If not: leave unpinned, add a comment noting the mcp dep must be
   re-verified on bump.
**Verify**: grep result documented in the commit message.
**Commit**: `dev-util/mcp-alertmanager: pin mcp dep below 2` (or
`dev-util/mcp-alertmanager: verify mcp 2.x compatibility (no fastmcp import)`)

---

## Task 1.5 — Validation

**Goal**: all changes pass the overlay's validation gates.
**Files**: none (verification only)
**Steps**:
1. `sudo ebuild <each touched ebuild> info` — all parse OK.
2. `emerge --pretend` on one representative per package (semgrep,
   ebuild-updater, x402, mcp-pagerduty) — resolves mcp-1.28.1.
3. `pytest scripts/tests/`
4. `openspec validate --all`
**Verify**: all gates pass. Note: pkgcheck is broken on this host
(Python 3.14 TypeError in pkgcheck/checks/python.py) — record as known
limitation, do not block on it.
**Commit**: (no commit — verification only)
