// Gentoo ebuild shim: OpenCode v2 resolves a plugin directory by checking
// for a root-level server.js/index.js entrypoint. Upstream ships dist/index.js.
// Dual V1/V2 entrypoint:
//   V2 reads `default` which already contains { id: "devtheops.otel", setup }.
//   V1 reads the named `server` or `default.server` export.
import plugin from "./dist/index.js";
export { default } from "./dist/index.js";
export * from "./dist/index.js";
export const server = plugin.setup || plugin.server || plugin;
