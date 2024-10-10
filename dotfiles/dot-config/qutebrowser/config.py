import catppuccin
import os

# pyright: ignore[reportUndefinedVariable]

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig()


# Colors
home = os.getenv("HOME")
lastcolor = ""
with open(f"{home}/.local/share/nvim/last-color", "r") as f:
    lastcolor = f.readline()
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
from qutebrowser.api import interceptor


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
c.bindings.commands = {
    "normal": {
        "<Meta-->": "zoom-out",
        "<Meta-=>": "zoom-in",
        "<Ctrl-o>": "back",
        "<Ctrl-i>": "forward",
    }
}
c.colors.webpage.darkmode.enabled = color != "latte"
c.content.autoplay = False
c.content.javascript.clipboard = "access"
c.content.pdfjs = True
c.editor.command = ["code", "{file}"]
c.fonts.default_size = "18pt"
c.fonts.statusbar = "default_size JetBrainsMono Nerd Font"
c.qt.args = ["disable-logging", "disable-reading-from-canvas"]
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
c.tabs.pinned.frozen = True
c.tabs.pinned.shrink = False
c.tabs.title.format_pinned = "📌{audio}{index}: {current_title}"
c.tabs.position = "left"
c.tabs.show = "switching"
c.tabs.width = "25%"
c.url.searchengines["gh"] = "https://github.com/{}"
c.url.searchengines["ghs"] = "https://github.com/search?q={}"
c.zoom.default = "120%"
