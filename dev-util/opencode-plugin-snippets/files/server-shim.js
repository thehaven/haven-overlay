// Gentoo ebuild shim: OpenCode v2 directory resolution root entrypoint.
// Upstream dist/index.js exports { id: "opencode-snippets:autocomplete", setup, tui }.
import plugin from "./dist/index.js";
export { default } from "./dist/index.js";
export * from "./dist/index.js";
export const server = plugin.setup || plugin.server || plugin;
