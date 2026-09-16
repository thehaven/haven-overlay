# Tasks

## 1. Regression test (RED)

- [x] 1.1 Add `scripts/tests/test_mcp_pin.py`: for every ebuild in the
      overlay whose source imports `mcp.server.fastmcp`, assert the
      `dev-python/mcp` dep is pinned below 2 (`<dev-python/mcp-2` or
      `<dev-python/mcp-3` with a compat patch) [unit]
- [x] 1.2 Confirm the test FAILS against the current tree (semgrep,
      ebuild-updater, x402, mcp-pagerduty are unpinned) (RED)

## 2. Implement fix (GREEN)

- [x] 2.1 `app-vuln/semgrep` 1.168.0–1.177.0 (10 ebuilds): pin
      `>=dev-python/mcp-1.28.1 <dev-python/mcp-2` with a comment above
      the RDEPEND string
- [x] 2.2 `dev-util/ebuild-updater` 2.8.2–2.10.6, 9999 (11 ebuilds):
      pin the `mcp?` dep to `>=1.28.1 <2`
- [x] 2.3 `dev-python/x402` 2.14.0–2.23.0 (10) + `dev-util/mcp-pagerduty`
      0.17.0 (1): pin to `>=1.28.1 <2`
- [x] 2.4 `dev-util/mcp-alertmanager` 1.1.0, 1.2.0: fetch source, verify
      fastmcp import; pin if importer, else document as 2.x-safe
- [x] 2.5 Confirm the regression test PASSES against the fixed tree (GREEN)

## 3. Build + smoke

- [x] 3.1 `sudo ebuild <each touched ebuild> info` parses OK;
      `emerge --pretend` on one representative per package resolves
      mcp-1.28.1
- [x] 3.2 Full `pytest scripts/tests/` passes; `openspec validate --all`
      passes (pkgcheck broken on this host — Python 3.14 TypeError,
      known limitation)
