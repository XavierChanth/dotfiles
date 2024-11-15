# pyright: basic, reportUndefinedVariable=false, reportMissingImports=false
import os
import catppuccin

# load your autoconfig, use this, if the rest of your config is empty!

config.load_autoconfig()

gui_editor = "zed"
uname = os.uname()
if uname[0] == "Darwin":
    gui_editor = "/opt/homebrew/bin/zed"

# Colors
HOME = os.getenv("HOME")
lastcolor = ""
with open(f"{HOME}/.local/share/nvim/last-color", "r") as f:
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

# config
c.aliases = {
    "q": "close",
    "qa": "quit",
    "w": "session-save",
    "wq": "quit --save",
    "wqa": "quit --save",
    "mpv": "spawn --userscript mpv",
    "bw": "spawn --userscript bitwarden",
}
c.bindings.commands = {
    "normal": {
        "<Enter>": "nop",
        "<Ctrl-o>": "back",
        "<Ctrl-h>": "back",
        "<Ctrl-i>": "forward",
        "<Ctrl-l>": "forward",
        "<Meta-->": "zoom-out",
        "<Meta-=>": "zoom-in",
        "<Meta-0>": "zoom",
        "<Meta-w>": "close",
        "<Meta-q>": "quit --save",
        "=": "nop",
        "gh": "home",
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
        "wi": "devtools bottom",
    },
}
c.colors.webpage.bg = "white"
c.colors.webpage.darkmode.enabled = False
c.colors.webpage.darkmode.threshold.background = 0
c.colors.webpage.darkmode.threshold.foreground = 256
c.content.autoplay = False
c.content.javascript.clipboard = "access"  # "none"
c.content.pdfjs = True
c.content.user_stylesheets = [f"{HOME}/.config/qutebrowser/stylesheets/code.css"]
c.downloads.position = "bottom"
c.editor.command = [gui_editor, "--wait", "{file}"]
c.fonts.default_size = "18pt"
c.fonts.statusbar = "default_size JetBrainsMono Nerd Font"
c.fonts.web.family.fixed = "JetBrainsMono Nerd Font"
c.prompt.filebrowser = False
c.qt.args = [
    "disable-logging",
    "disable-reading-from-canvas",
]
c.scrolling.smooth = True
c.statusbar.padding = {"top": 8, "bottom": 8, "left": 8, "right": 8}
c.statusbar.position = "bottom"
c.statusbar.show = "in-mode"
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
c.url.searchengines["s"] = "https://duckduckgo.com/?q={}"
c.url.searchengines["gh"] = "https://github.com/{}"
c.url.searchengines["ghs"] = "https://github.com/search?q={}"
c.window.hide_decoration = False  # Incompatible with aerospace
c.zoom.default = "120%"
