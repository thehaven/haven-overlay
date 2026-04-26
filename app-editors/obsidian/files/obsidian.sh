#!/bin/bash
# Native Gentoo Obsidian Wrapper
# Handles Ozone (Wayland) and Sandbox settings

FLAGS=()

# Wayland support
if [[ "${XDG_SESSION_TYPE}" == "wayland" ]]; then
    FLAGS+=(
        "--ozone-platform-hint=auto"
        "--enable-features=WaylandWindowDecorations"
    )
fi

# Pass-through any user-provided flags
exec /opt/obsidian/obsidian "${FLAGS[@]}" "$@"
