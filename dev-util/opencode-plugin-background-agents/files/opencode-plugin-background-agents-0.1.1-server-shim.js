// Gentoo ebuild shim: Dual V1/V2 entrypoint for opencode-background-agents.
// Upstream dist/index.js exports default function BackgroundAgentsPlugin (V1).
// V2 expects default export with { id, setup }.
import BackgroundAgentsPlugin from "./dist/index.js";

export { BackgroundAgentsPlugin, BackgroundAgentsPlugin as server };
export default {
  id: "opencode-background-agents",
  async setup(ctx) {},
  server: BackgroundAgentsPlugin,
};
