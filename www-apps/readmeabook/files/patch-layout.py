#!/usr/bin/env python3
"""Patch layout.tsx to use next/font/local instead of next/font/google."""
import sys
import os
import re


def patch_layout(layout_path, fonts_dir):
    with open(layout_path, 'r') as f:
        content = f.read()

    content = content.replace(
        'import { Geist, Geist_Mono } from "next/font/google";',
        'import localFont from "next/font/local";'
    )

    woff2_files = sorted([
        f for f in os.listdir(fonts_dir) if f.endswith('.woff2')
    ]) if os.path.isdir(fonts_dir) else []

    if not woff2_files:
        print("WARNING: No .woff2 files found in fonts directory",
              file=sys.stderr)
        return

    geist_files = [f for f in woff2_files
                   if 'Geist' in f and 'Mono' not in f]
    geist_mono_files = [f for f in woff2_files
                        if 'GeistMono' in f or 'Geist-Mono' in f]

    if not geist_files:
        geist_files = woff2_files[:1]
    if not geist_mono_files:
        geist_mono_files = woff2_files[-1:]

    geist_src = ",\n    ".join(
        [f'{{ src: "/fonts/{f}" }}' for f in geist_files]
    )
    geist_mono_src = ",\n    ".join(
        [f'{{ src: "/fonts/{f}" }}' for f in geist_mono_files]
    )

    geist_decl = (
        f'const geistSans = localFont({{\n'
        f'  variable: "--font-geist-sans",\n'
        f'  src: [\n    {geist_src}\n  ],\n}});'
    )
    geist_mono_decl = (
        f'const geistMono = localFont({{\n'
        f'  variable: "--font-geist-mono",\n'
        f'  src: [\n    {geist_mono_src}\n  ],\n}});'
    )

    pattern = r'const geistSans = Geist\(\{[^}]+\}\);.*?const geistMono = Geist_Mono\(\{[^}]+\}\);'
    replacement = geist_decl + "\n\n" + geist_mono_decl
    content = re.sub(pattern, replacement, content, flags=re.DOTALL)

    with open(layout_path, 'w') as f:
        f.write(content)

    print(f"Patched {layout_path} with local font declarations")


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <layout.tsx> <fonts_dir>",
              file=sys.stderr)
        sys.exit(1)
    patch_layout(sys.argv[1], sys.argv[2])
