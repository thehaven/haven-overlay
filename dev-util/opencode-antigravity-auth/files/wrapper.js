#!/usr/bin/env node

// Wrapper for opencode-antigravity-auth — fixes ES module directory import
// Installed by the Gentoo ebuild alongside dist/

import { AntigravityCLIOAuthPlugin, GoogleOAuthPlugin } from './src/plugin.js';

export {
  AntigravityCLIOAuthPlugin,
  GoogleOAuthPlugin
};

export default AntigravityCLIOAuthPlugin;
