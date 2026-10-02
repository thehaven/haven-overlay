## 1. Restore the tag (preferred)

- [x] 1.1 Operator/Agent: push tag `v0.1.0` to gitlab-ee origin
- [x] 1.2 Verify as the portage user (regression gate, RED → GREEN): `sudo -u portage git ls-remote https://gitlab-ee.thehavennet.org.uk/ai-ml/mem0-mcp.git refs/tags/v0.1.0` resolves
- [x] 1.3 Real fetch smoke test: `sudo -u portage ebuild app-misc/mem0-mcp/mem0-mcp-0.1.0.ebuild unpack` succeeds

## 2. Fallback: retire the versioned ebuild (N/A - tag restored)

- [x] 2.1 Preserved versioned ebuild (tag restored)
- [x] 2.2 Metadata cache verified

## 3. Verify

- [x] 3.1 Full gate run: URI resolves and unpacks cleanly under portage userpriv
- [x] 3.2 Confirm both mem0-mcp-0.1.0 and mem0-mcp-9999 build
