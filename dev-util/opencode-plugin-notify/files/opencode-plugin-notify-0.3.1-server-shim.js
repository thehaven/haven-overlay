// Gentoo ebuild shim: Dual V1/V2 entrypoint for opencode-notify.
// Upstream dist/index.js exports default function opencodeNotifyPlugin (V1).
// V2 expects default export to be a plain object with { id, setup }.
import opencodeNotifyPlugin from "./dist/index.js";
export * from "./dist/index.js";

async function setup(ctx) {
  const hooks = await opencodeNotifyPlugin({
    client: ctx.client,
  });
  if (hooks?.["tool.execute.before"] && ctx.tool?.hook) {
    await ctx.tool.hook("execute.before", async (event) => {
      if (!event) return;
      await hooks["tool.execute.before"](
        { tool: event.tool, sessionID: event.sessionID, callID: event.callID },
        { args: event.input }
      );
    });
  }
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
  id: "opencode-notify",
  setup,
  server: opencodeNotifyPlugin,
};

export { opencodeNotifyPlugin as server, setup };
export default plugin;
