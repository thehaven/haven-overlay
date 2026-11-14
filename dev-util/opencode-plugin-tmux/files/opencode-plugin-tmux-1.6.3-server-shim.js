// Gentoo ebuild shim: Dual V1/V2 entrypoint for opentmux.
// Upstream dist/index.js exports default function OpencodeAgentTmux (V1).
// V2 expects default export to be a plain object with { id, setup }.
import OpencodeAgentTmux from "./dist/index.js";
export * from "./dist/index.js";

async function setup(ctx) {
  const hooks = await OpencodeAgentTmux({
    client: ctx.client,
    directory: ctx.location?.directory ?? ctx.directory,
    serverUrl: ctx.server?.url ?? ctx.serverUrl,
  });
  if (hooks?.event && ctx.event?.subscribe) {
    void (async () => {
      try {
        for await (const event of await ctx.event.subscribe()) {
          await hooks.event({ event });
        }
      } catch {}
    })();
  }
}

const plugin = {
  id: "opentmux",
  setup,
  server: OpencodeAgentTmux,
};

export { OpencodeAgentTmux as server, setup };
export default plugin;
