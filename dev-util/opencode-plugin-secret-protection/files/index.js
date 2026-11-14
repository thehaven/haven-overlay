const BLOCKED_PATTERNS = [
  /\.env$/i,
  /\.pem$/i,
  /_key\./i,
  /id_rsa/i,
  /id_ed25519/i,
  /\.p12$/i,
  /\.pfx$/i,
  /secrets\.yaml$/i,
  /kubeconfig$/i,
  /password-store/i,
  /\.tokens?\.pass$/i,
];

function checkPath(filePath) {
  if (!filePath || typeof filePath !== "string") return;
  for (const pattern of BLOCKED_PATTERNS) {
    if (pattern.test(filePath)) {
      throw new Error(
        `BLOCKED: Refusing to read potential secret file matching pattern: ${pattern}`
      );
    }
  }
}

export const SecretProtection = async () => ({
  "tool.execute.before": async (input, _output) => {
    const tool = input.tool || input.name || "";
    const readTools = [
      "read",
      "Read",
      "ReadFiles",
      "read_file",
      "desktop-commander_read_file",
      "wcgw_ReadFiles",
    ];
    if (!readTools.some((t) => tool === t)) return;
    const filePath =
      input.args?.filePath ||
      input.args?.path ||
      input.input?.filePath ||
      input.input?.path ||
      JSON.stringify(input.args || input.input || "");
    checkPath(filePath);
  },
});

async function setup(ctx) {
  if (ctx.tool?.hook) {
    await ctx.tool.hook("execute.before", async (event) => {
      if (!event) return;
      const tool = event.tool ?? "";
      const readTools = [
        "read",
        "Read",
        "ReadFiles",
        "read_file",
        "desktop-commander_read_file",
        "wcgw_ReadFiles",
      ];
      if (!readTools.some((t) => tool === t)) return;
      const input = event.input;
      const filePath =
        (typeof input === "object" && input !== null
          ? input.filePath || input.path
          : "") || JSON.stringify(input ?? "");
      checkPath(filePath);
    });
  }
}

const plugin = { id: "secret-protection", setup, server: SecretProtection };
export { SecretProtection as server, setup };
export default plugin;
