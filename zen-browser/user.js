// see about:config for where these are set
// Updates and setup
user_pref("zen.welcomeScreen.seen", true);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("app.update.auto", false);

// New tab page
user_pref("browser.newtabpage.pinned", "[]");
user_pref("browser.tabs.inTitlebar", 1);
user_pref("browser.newtabpage.activity-stream.showWeather", false);
user_pref("browser.newtabpage.pinned", "[]");

// Customization
user_pref(
  "browser.uiCustomization.state",
  '{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["jid1-mnnxcxisbpnsxq_jetpack-browser-action","ublock0_raymondhill_net-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","contact_maxhu_dev-browser-action","toggledarkmode_example_com-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","treestyletab_piro_sakura_ne_jp-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","vertical-spacer","customizableui-special-spring40","developer-button","urlbar-container","keepassxc-browser_keepassxc_org-browser-action","customizableui-special-spring2","wrapper-sidebar-button","downloads-button","unified-extensions-button","preferences-button"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","customizableui-special-spring37","alltabs-button"],"vertical-tabs":[],"PersonalToolbar":["personal-bookmarks"],"zen-sidebar-top-buttons":["zen-expand-sidebar-button","new-tab-button"],"zen-sidebar-bottom-buttons":["zen-workspaces-button"],"zen-sidebar-icons-wrapper":["sidebar-button","password-manager-firefox-extension_apple_com-browser-action","zen-workspaces-button","zen-profile-button","preferences-button"]},"seen":["developer-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","contact_maxhu_dev-browser-action","toggledarkmode_example_com-browser-action","password-manager-firefox-extension_apple_com-browser-action","ublock0_raymondhill_net-browser-action","keepassxc-browser_keepassxc_org-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action","treestyletab_piro_sakura_ne_jp-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","TabsToolbar","unified-extensions-area","zen-sidebar-icons-wrapper","zen-sidebar-top-buttons","vertical-tabs","zen-sidebar-bottom-buttons"],"currentVersion":21,"newElementCount":52}',
);
user_pref("font.name.monospace.x-western", "JetBrainsMono Nerd Font Mono");
user_pref("font.size.monospace.x-western", 14);
user_pref("ui.textScaleFactor", 120);

user_pref("zen.view.use-single-toolbar", false);
user_pref("browser.bookmarks.restore_default_bookmarks", false);
user_pref("browser.toolbars.bookmarks.visibility", "newtab");
user_pref("uc.bookmarks.hide-favicons", false);
user_pref("uc.bookmarks.hide-folder-icons", true);

// Privacy & security
user_pref("permissions.isolateBy.privateBrowsing", true);
user_pref("permissions.isolateBy.userContext", true);
user_pref("privacy.userContext.enabled", true);
user_pref("signon.rememberSignons", false);
user_pref("security.ssl.require_safe_negotiation", true);
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", false);
user_pref("security.OCSP.enabled", 1);
