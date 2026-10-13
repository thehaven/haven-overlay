// Gentoo ebuild shim: Dual V1/V2 entrypoint for opencode-supermemory.
// Upstream dist/index.js only exports named { SupermemoryPlugin } (V1).
// V2 expects default export with { id, setup }.
import { SupermemoryPlugin } from "./dist/index.js";

export { SupermemoryPlugin, SupermemoryPlugin as server };
export default {
  id: "opencode-supermemory",
  async setup(ctx) {},
  server: SupermemoryPlugin,
};
