// Config docs:
//
//   https://glide-browser.app/config
//
// API reference:
//
//   https://glide-browser.app/api
//
// Default config files can be found here:
//
//   https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
//
// Most default keymappings are defined here:
//
//   https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
//
// Try typing `glide.` and see what you can do!
glide.prefs.set("sidebar.verticalTabs", true)
glide.prefs.set("browser.toolbarbuttons.introduced.sidebar-button", true)


glide.keymaps.set("normal", "<leader>e", () => {
  glide.keys.send("<C-A-z>")
})

// TODO for this browser
// - Get password manager working
// - Get FF containers working
// - Explore keymaps for tab folders as a poor man's container?
