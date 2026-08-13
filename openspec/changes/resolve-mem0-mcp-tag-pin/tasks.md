## 1. Restore the tag (preferred)

- [ ] 1.1 Operator: push tag `v0.1.0` (= `55a23354`) to gitlab-ee origin — requires deciding which lineage is canonical (`git push origin v0.1.0` from the local clone, or force-align with gitlab's main first) [smoke: tag visible on gitlab]
- [ ] 1.2 Verify as the portage user (regression gate, RED → GREEN): `sudo -u portage git ls-remote https://gitlab-ee.thehavennet.org.uk/ai-ml/mem0-mcp.git refs/tags/v0.1.0` resolves [smoke]
- [ ] 1.3 Real fetch smoke test: `sudo -u portage emerge --fetchonly =app-misc/mem0-mcp-0.1.0` [smoke]

## 2. Fallback: retire the versioned ebuild

- [ ] 2.1 If the tag cannot be restored: remove `mem0-mcp-0.1.0.ebuild` (`git rm`) or add it to `profiles/package.mask` with a comment citing the unfetchable pin [unit: `ls app-misc/mem0-mcp/` / `grep mem0-mcp profiles/package.mask`]
- [ ] 2.2 Regenerate the metadata cache: `sudo -n egencache --repo=haven-overlay --update` [integration]

## 3. Verify

- [ ] 3.1 Full gate run: `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh` — exit 0 or only actionable failures [smoke]
- [ ] 3.2 If retired: confirm `emerge =app-misc/mem0-mcp-0.1.0` is blocked/masked and 9999 still builds [integration]
