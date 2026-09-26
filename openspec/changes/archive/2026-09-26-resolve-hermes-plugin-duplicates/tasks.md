## 3. Verify

- [x] 3.1 `ebuild-updater duplicates --json` no longer lists the
      `hermes-plugin-*` cluster under unapproved groups
      [smoke: `jq -r '.unapproved[] | select(.atoms[] | contains("hermes-plugin")) | .atoms[]' /tmp/dupes.json | wc -l` → 0]
      *(verified 2026-09-26: `/tmp/dupes-after.json` is `[]`; the full
      hermes cluster is now `allowed: true`)*
- [ ] 3.2 Next nightly run: no `Skipping app-misc/hermes-plugin-*: duplicate
      upstream hold` warning lines
      [smoke: `grep -c "hermes-plugin-.*duplicate-upstream hold" /var/log/ebuild-updater.log` → 0]

## 2. Add `[[duplicates.allow]]` entry

- [ ] 2.1 Append a `[[duplicates.allow]]` block to
      `/etc/ebuild-updater/config.toml` (after the existing `[advisory]`
      and `[duplicates]` sections) with:
      - `atoms`: every atom from 1.1 plus `app-misc/hermes-plugin-browser`
      - `reason`: at least 10 characters, explaining the monorepo split
        [unit: `grep -A4 "^\[\[duplicates.allow\]\]" /etc/ebuild-updater/config.toml`]

## 3. Verify

- [ ] 3.1 `ebuild-updater duplicates --json --repo haven-overlay` no longer
      lists the `hermes-plugin-*` cluster under unapproved groups
      [smoke: `jq -r '.unapproved[] | select(.atoms[] | contains("hermes-plugin")) | .atoms[]' /tmp/dupes.json | wc -l` → 0]
- [ ] 3.2 Next nightly run: no `Skipping app-misc/hermes-plugin-*: duplicate
      upstream hold` warning lines
      [smoke: `grep -c "hermes-plugin-.*duplicate-upstream hold" /var/log/ebuild-updater.log` → 0]
- [ ] 3.3 `openspec validate resolve-hermes-plugin-duplicates --strict`
      passes [integration]
- [ ] 3.4 Full gate: `openspec validate --all --strict` exit 0
      [integration]