#!/bin/bash
# Haven Overlay — MCP Ecosystem Verification script
# Validates that all packaged MCP servers can start and import their dependencies.

echo "🔍 Starting MCP Ecosystem Verification..."
echo "----------------------------------------"

BINARIES=(
    "/usr/bin/mcp-server-analyzer"
    "/usr/bin/mcp-server-brave-search"
    "/usr/bin/mcp-server-docker"
    "/usr/bin/mcp-server-github"
    "/usr/bin/mcp-server-kubernetes"
    "/usr/bin/mcp-server-memory"
    "/usr/bin/mcp-server-opentofu"
    "/usr/bin/mcp-server-pass"
    "/usr/bin/mcp-server-postgres"
    "/usr/bin/mcp-server-sequential-thinking"
    "/usr/bin/mcp-server-tree-sitter"
    "/usr/bin/mediawiki-mcp-server"
    "/usr/bin/obsidian-mcp"
    "/usr/bin/terraform-mcp-server"
    "/usr/bin/wcgw"
    "/usr/bin/wcgw_local"
    "/usr/bin/wcgw_mcp"
)

failed=0
passed=0
skipped=0

for bin in "${BINARIES[@]}"; do
    if [ ! -f "$bin" ]; then
        echo "⏭️  SKIP: $bin (not installed)"
        skipped=$((skipped + 1))
        continue
    fi
    
    # Run for 2 seconds to check for immediate import failures
    output=$(timeout 2s "$bin" --version 2>&1)
    exit_code=$?
    
    if [ $exit_code -eq 124 ] || [ $exit_code -eq 0 ]; then
        echo "✅ PASS: $bin"
        passed=$((passed + 1))
    else
        if echo "$output" | grep -qE "Traceback|ModuleNotFoundError|ImportError"; then
            echo "❌ FAIL: $bin (Import/Runtime Error)"
            echo "$output" | grep -A 5 -E "Traceback|ModuleNotFoundError|ImportError"
            failed=$((failed + 1))
        else
            echo "✅ PASS: $bin (CLI flag mismatch but no import error)"
            passed=$((passed + 1))
        fi
    fi
done

echo "----------------------------------------"
echo "Summary: $passed passed, $failed failed, $skipped skipped."

if [ $failed -gt 0 ]; then
    exit 1
fi
exit 0
