import type { Plugin } from "@opencode-ai/plugin"

export const EnvProtection: Plugin = async () =>
({
  "tool.execute.before": async (input, output) => {
    if (input.tool === "read" && output.args.filePath.includes(".env")) {
      throw new Error("Do not read .env files");
    }
  }
})

