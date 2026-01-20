import type { Plugin } from "@opencode-ai/plugin"

const bellEvents = new Set(["session.idle", "session.error"])
const notifyEvents = new Set([
  "session.idle",
  "session.error",
  "permission.updated",
  "permission.replied",
  "session.status",
])

let lastIdleNotifyAt = 0

const notifyAttention = (title: string, body: string, urgency = "normal") => {
  const home = process.env.HOME ?? ""
  const notifyPath = `${home}/.local/bin/notify-attention`
  Bun.spawn([notifyPath, "OpenCode", title, body, urgency], {
    stdout: "ignore",
    stderr: "ignore",
  })
}

export const Notifications: Plugin = async () => {
  return {
    event: async ({ event }) => {
      return;
      if (bellEvents.has(event.type)) {
        await Bun.write(Bun.stdout, "\x07")
      }

      if (notifyEvents.has(event.type)) {
        if (event.type === "session.status") {
          if (event.properties?.status?.type !== "idle") return
          const now = Date.now()
          if (now - lastIdleNotifyAt < 2000) return
          lastIdleNotifyAt = now
          notifyAttention("OpenCode idle", "Session is waiting for input.")
          return
        }

        if (event.type === "session.error") {
          notifyAttention("OpenCode error", "Session error occurred.", "critical")
          return
        }

        if (event.type === "permission.updated") {
          notifyAttention("OpenCode approval", "Approval requested.", "normal")
          return
        }

        if (event.type === "permission.replied") {
          notifyAttention("OpenCode approval", "Approval response recorded.")
          return
        }

        if (event.type === "session.idle") {
          const now = Date.now()
          if (now - lastIdleNotifyAt < 2000) return
          lastIdleNotifyAt = now
          notifyAttention("OpenCode idle", "Session is waiting for input.")
          return
        }

        notifyAttention("OpenCode idle", "Session is waiting for input.")
      }
    },
  }
}
