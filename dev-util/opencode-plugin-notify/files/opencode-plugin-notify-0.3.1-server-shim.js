// Gentoo ebuild shim: Dual V1/V2 entrypoint for opencode-notify.
// Upstream dist/index.js exports default function opencodeNotifyPlugin (V1).
// V2 expects default export with { id, setup }.
import opencodeNotifyPlugin from "./dist/index.js";

export { opencodeNotifyPlugin, opencodeNotifyPlugin as server };
export default {
  id: "opencode-notify",
  async setup(ctx) {},
  server: opencodeNotifyPlugin,
};
