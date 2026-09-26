## 1. Pin `dev-python/fastmcp` and `dev-python/caio` on the hold list

- [x] 1.1 Add `"dev-python/fastmcp",` and `"dev-python/caio",` to the
      `[repos.haven-overlay.pipeline].hold` array in
      `/var/db/repos/haven-overlay/ebuild-updater.toml`, immediately after
      the existing `"dev-python/mcp",` entry (line 73), with a single
      shared comment line above them referencing the existing mcp hold
      [unit: `grep -nE "fastmcp|caio" ebuild-updater.toml` returns the
      two new lines plus the existing mcp line]
      *(applied 2026-09-26: lines 77-78; TOML re-parse OK)*

## 2. Align gates

- [ ] 2.1 Regenerate metadata cache: `sudo -n egencache --repo=haven-overlay
      --update` [integration: exit 0]
- [ ] 2.2 Confirm `ebuild-updater status` no longer proposes bumps for
      `dev-python/fastmcp` or `dev-python/caio`
      [smoke: `ebuild-updater status --repo haven-overlay 2>&1 | grep -E "dev-python/(fastmcp|caio)" | grep -v "held" || echo "OK"`]

## 3. Verify

- [ ] 3.1 `openspec validate hold-fastmcp-caio-below-mcp-2 --strict` passes
      [integration: exit 0]
- [ ] 3.2 Next nightly run: `reinstall preflight: emerge --pretend failed
      rc=1` warning does NOT mention `dev-python/fastmcp` or
      `dev-python/caio` in its dep-graph-unsatisfiable atoms
      [smoke: `awk '/fastmcp|caio/ && /dep-graph/' /var/log/ebuild-updater.log | wc -l` → 0]
- [ ] 3.3 Full gate: `openspec validate --all --strict` exit 0
      [integration]