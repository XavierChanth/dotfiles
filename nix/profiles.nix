# Profile lists are deliberately explicit (rather than inherited) so their
# composition remains reviewable as profiles diverge.
{
  darwin-workstation = [ "editor-core" "terminal-core" "ssh" "ai-applications" "ghostty" "mise-workstation" "workstation-packages" ];
  darwin-server = [ "editor-core" "terminal-core" "ssh" "ai-applications" "server-packages" ];
  linux-workstation = [ "editor-core" "terminal-core" "ssh" "ai-applications" "ghostty" "mise-workstation" "workstation-packages" ];
  linux-server = [ "editor-core" "terminal-core" "ssh" "ai-applications" "server-packages" ];
}
