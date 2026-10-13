// Gentoo ebuild shim: Dual V1/V2 entrypoint for opentmux.
// Upstream dist/index.js exports default function OpencodeAgentTmux (V1).
// V2 expects default export with { id, setup }.
import OpencodeAgentTmux from "./dist/index.js";

export { OpencodeAgentTmux, OpencodeAgentTmux as server };
export default {
  id: "opentmux",
  async setup(ctx) {},
  server: OpencodeAgentTmux,
};
