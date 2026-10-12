// Gentoo ebuild shim: OpenCode v2 resolves a plugin *directory* by looking for
// a root-level `server.js` / `index.js` entrypoint. Upstream ships only
// dist/plugin.js. Re-export the dual V1/V2 entrypoint.
export { default } from "./dist/plugin.js";
export * from "./dist/plugin.js";
