// Gentoo ebuild shim: OpenCode v2 resolves a plugin *directory* by looking for
// a root-level `server.js` / `index.js` entrypoint. Upstream opencode-pty only
// ships dist/index.js, so v2 silently skipped the package. Re-export the dual
// V1/V2 entrypoint (V1 reads `server`; V2 reads `default`).
export { default } from "./dist/index.js";
export * from "./dist/index.js";
