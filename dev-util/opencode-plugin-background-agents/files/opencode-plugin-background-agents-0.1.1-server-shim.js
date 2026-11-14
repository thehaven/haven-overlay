// Gentoo ebuild shim: OpenCode v2 resolves a plugin *directory* without exports
// by looking for a root-level `server.js` / `index.js` entrypoint. Re-export
// the dual V1/V2 entrypoint from dist/index.js.
export { default } from "./dist/index.js";
export * from "./dist/index.js";
