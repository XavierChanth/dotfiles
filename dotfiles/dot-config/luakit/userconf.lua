require("adblock")
require("adblock_chrome")
require("unique_instance")
require("vertical_tabs")
require("select").label_maker = function(s)
	local chars = s.charset("asdfghjkl;")
	return s.trim(s.sort(s.reverse(chars)))
end

local settings = require("settings")
settings.set_setting("window.search_engines", {
	ddg = "https://duckduckgo.com?q=%s",
	gh = "https://github.com/%s",
}, {})
settings.set_setting("window.default_search_engine", "ddg", {})
settings.set_setting("window.home_page", "luakit://newtab", {})
