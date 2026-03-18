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

const inTmux = (): boolean => Boolean(process.env.TMUX)

const getTmuxInfo = (): string | null => {
  if (!inTmux()) return null
  const result = Bun.spawnSync(["tmux", "display-message", "-p", "#S:#I"])
  if (result.exitCode !== 0) return null
  const output = result.stdout.toString().trim()
  return output.length > 0 ? output : null
}

const isTmuxWindowActive = (): boolean => {
  if (!inTmux()) return false
  const result = Bun.spawnSync([
    "tmux",
    "display-message",
    "-p",
    "#{window_active}",
  ])
  if (result.exitCode !== 0) return false
  return result.stdout.toString().trim() === "1"
}

const getTmuxInfoForNotify = (): string | null => {
  const tmuxInfo = getTmuxInfo()
  if (!tmuxInfo) return null
  if (isTmuxWindowActive()) return null
  return tmuxInfo
}

const notifyAttention = (
  title: string,
  body: string,
  tmuxInfo: string | null,
  urgency = "normal",
) => {
  const home = process.env.HOME ?? ""
  const notifyPath = `${home}/.local/bin/notify-attention`
  const fullBody = tmuxInfo ? `${body} [${tmuxInfo}]` : body
  Bun.spawn([notifyPath, "OpenCode", title, fullBody, urgency], {
    stdout: "ignore",
    stderr: "ignore",
  })
}

export const Notifications: Plugin = async () =>
({
  event: async ({ event }) => {
    if (bellEvents.has(event.type)) {
      await Bun.write(Bun.stdout, "\x07")
    }

    if (notifyEvents.has(event.type)) {
      if (event.type === "session.status") {
        if (event.properties?.status?.type !== "idle") return
        const now = Date.now()
        if (now - lastIdleNotifyAt < 2000) return
        lastIdleNotifyAt = now
        const tmuxInfo = getTmuxInfoForNotify()
        if (!tmuxInfo) return
        notifyAttention(
          "OpenCode idle",
          "Session is waiting for input.",
          tmuxInfo,
        )
        return
      }

      if (event.type === "session.error") {
        const tmuxInfo = getTmuxInfoForNotify()
        if (!tmuxInfo) return
        notifyAttention(
          "OpenCode error",
          "Session error occurred.",
          tmuxInfo,
          "critical",
        )
        return
      }

      if (event.type === "permission.updated") {
        const tmuxInfo = getTmuxInfoForNotify()
        if (!tmuxInfo) return
        notifyAttention(
          "OpenCode approval",
          "Approval requested.",
          tmuxInfo,
          "normal",
        )
        return
      }

      if (event.type === "permission.replied") {
        const tmuxInfo = getTmuxInfoForNotify()
        if (!tmuxInfo) return
        notifyAttention(
          "OpenCode approval",
          "Approval response recorded.",
          tmuxInfo,
        )
        return
      }

      if (event.type === "session.idle") {
        const now = Date.now()
        if (now - lastIdleNotifyAt < 2000) return
        lastIdleNotifyAt = now
        const tmuxInfo = getTmuxInfoForNotify()
        if (!tmuxInfo) return
        notifyAttention(
          "OpenCode idle",
          "Session is waiting for input.",
          tmuxInfo,
        )
        return
      }

      const tmuxInfo = getTmuxInfoForNotify()
      if (!tmuxInfo) return
      notifyAttention(
        "OpenCode idle",
        "Session is waiting for input.",
        tmuxInfo,
      )
    }
  },
})
