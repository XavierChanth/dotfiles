import type { Plugin } from "@opencode-ai/plugin"
const events = [
  "session.idle",
  "session.error"
  // , "permission.updated"
]
export const TerminalBell: Plugin = async () => {
  return {
    event: async ({ event }) => {
      if (events.includes(event.type)) {
        await Bun.write(Bun.stdout, "\x07")
      }
    }
  }
}
