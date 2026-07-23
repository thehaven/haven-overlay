#!/usr/bin/env bash
# verify-npm-bin.sh — audit all inherit-npm ebuilds for missing npm_install_bin
# Recognises both explicit npm_install_bin calls and NPM_AUTO_BIN (eclass auto-bin).
# Fail the script if any ebuild's package.json declares a bin with no symlink coverage.
set -euo pipefail

overlay="${1:-/var/db/repos/haven-overlay}"
errors=0
checked=0

echo "=== npm_install_bin / NPM_AUTO_BIN audit ==="

for ebuild in $(find "${overlay}" -name '*.ebuild' -type f | sort); do
	grep -q 'inherit npm' "${ebuild}" 2>/dev/null || continue

	npm_module=$(grep -oP 'NPM_MODULE="\K[^"]+' "${ebuild}" 2>/dev/null || true)
	[[ -z ${npm_module} ]] && continue

	pkg_json="/usr/lib64/node_modules/${npm_module}/package.json"
	[[ -f ${pkg_json} ]] || continue

	bin=$(python3 -c "import json; d=json.load(open('${pkg_json}')); b=d.get('bin',''); print(b if isinstance(b,str) else list(b.keys())[0] if isinstance(b,dict) else '')" 2>/dev/null || true)
	[[ -z ${bin} ]] && continue

	checked=$((checked + 1))

	if grep -qE 'npm_install_bin|NPM_AUTO_BIN' "${ebuild}" 2>/dev/null; then
		method=$(grep -q 'NPM_AUTO_BIN' "${ebuild}" 2>/dev/null && echo "auto-bin" || echo "explicit")
		echo "  OK   ${ebuild##*/repos/haven-overlay/}  (bin: ${bin}, via: ${method})"
	else
		echo "  FAIL ${ebuild##*/repos/haven-overlay/}  (bin: ${bin}) — MISSING npm_install_bin / NPM_AUTO_BIN"
		errors=$((errors + 1))
	fi
done

echo ""
echo "Checked: ${checked} ebuilds, Errors: ${errors}"
[[ ${errors} -eq 0 ]] && echo "PASS: all npm_install_bin or NPM_AUTO_BIN present" || echo "FAIL: ${errors} ebuild(s) missing bin symlink coverage"
exit ${errors}
