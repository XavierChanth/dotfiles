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
  '{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","contact_maxhu_dev-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","customizableui-special-spring4","urlbar-container","customizableui-special-spring2","downloads-button","wrapper-sidebar-button","developer-button","unified-extensions-button"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","alltabs-button"],"PersonalToolbar":["personal-bookmarks"],"zen-sidebar-top-buttons":["zen-expand-sidebar-button","zen-workspaces-button","new-tab-button"],"zen-sidebar-icons-wrapper":["sidebar-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","zen-profile-button","preferences-button"]},"seen":["developer-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","contact_maxhu_dev-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","TabsToolbar","unified-extensions-area","zen-sidebar-icons-wrapper","zen-sidebar-top-buttons"],"currentVersion":20,"newElementCount":30}',
);
user_pref("font.name.monospace.x-western", "JetBrainsMono Nerd Font Mono");
user_pref("font.size.monospace.x-western", 14);
user_pref("ui.textScaleFactor", 120);

// Privacy & security
user_pref("permissions.isolateBy.privateBrowsing", true);
user_pref("permissions.isolateBy.userContext", true);
user_pref("privacy.userContext.enabled", true);
user_pref("signon.rememberSignons", false);
user_pref("security.ssl.require_safe_negotiation", true);
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", false);
user_pref("security.OCSP.enabled", 1);
