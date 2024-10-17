# pyright: basic, reportUndefinedVariable=false, reportMissingImports=false
import os

from qutebrowser.api import interceptor

import catppuccin

# load your autoconfig, use this, if the rest of your config is empty!

config.load_autoconfig()


# Colors
home = os.getenv("HOME")
lastcolor = ""
with open(f"{home}/.local/share/nvim/last-color", "r") as f:
    lastcolor = f.readline().strip()
    f.close()

colors = {
    "catppuccin-mocha": "mocha",
    "catppuccin-macchiato": "macchiato",
    "catppuccin-frappe": "frappe",
    "catppuccin-latte": "latte",
    "tokyonight-night": "mocha",
    "tokyonight-moon": "macchiato",
    "tokyonight-storm": "frappe",
    "tokyonight-day": "latte",
}

color = colors.get(lastcolor, "macchiato")
catppuccin.setup(c, color, True)

# YouTube ad-block


def filter_yt(info: interceptor.Request):
    """Block the given request if necessary."""
    url = info.request_url
    if (
        url.host() == "www.youtube.com"
        and url.path() == "/get_video_info"
        and "&adformat=" in url.query()
    ):
        info.block()


interceptor.register(filter_yt)

# config
c.aliases = {
    "q": "close",
    "qa": "quit",
    "w": "session-save",
    "wq": "quit --save",
    "wqa": "quit --save",
}
c.bindings.commands = {
    "normal": {
        "<Ctrl-o>": "back",
        "<Ctrl-i>": "forward",
        "<Meta-->": "zoom-out",
        "<Meta-=>": "zoom-in",
        "<Meta-1>": "tab-focus 1",
        "<Meta-2>": "tab-focus 2",
        "<Meta-3>": "tab-focus 3",
        "<Meta-4>": "tab-focus 4",
        "<Meta-5>": "tab-focus 5",
        "<Meta-6>": "tab-focus 6",
        "<Meta-7>": "tab-focus 7",
        "<Meta-8>": "tab-focus 8",
        "<Meta-9>": "tab-focus 9",
        "<Meta-m>": "tab-mute",
        "<Ctrl-m>": "mark-set",
        "<Meta-r>": "config-source",
        "td": "config-cycle colors.webpage.darkmode.enabled true false",
        "tt": "config-cycle tabs.show switching always",
    },
    "insert": {"<Ctrl-b>": "spawn --userscript bitwarden"},
}
c.colors.webpage.bg = "white"
c.colors.webpage.darkmode.enabled = color != "latte"
c.colors.webpage.darkmode.threshold.background = 0
c.colors.webpage.darkmode.threshold.foreground = 256
c.content.autoplay = False
c.content.javascript.clipboard = "access"
c.content.pdfjs = True
c.downloads.position = "bottom"
c.editor.command = ["neovide", "{file}"]
c.fonts.default_size = "18pt"
c.fonts.statusbar = "default_size JetBrainsMono Nerd Font"
c.qt.args = [
    "disable-logging",
    "disable-reading-from-canvas",
]
c.scrolling.smooth = True
c.statusbar.padding = {"top": 8, "bottom": 8, "left": 0, "right": 8}
c.statusbar.position = "top"
c.statusbar.widgets = [
    "progress",
    "history",
    "tabs",
    "text:|",
    "url",
    "search_match",
    "text:|",
    "scroll",
]
c.tabs.last_close = "startpage"
c.tabs.pinned.frozen = True
c.tabs.pinned.shrink = False
c.tabs.position = "right"
c.tabs.show = "switching"
c.tabs.title.format_pinned = "📌{audio}{index}: {current_title}"
c.tabs.width = "15%"
c.url.searchengines["gh"] = "https://github.com/{}"
c.url.searchengines["ghs"] = "https://github.com/search?q={}"
c.zoom.default = "120%"
