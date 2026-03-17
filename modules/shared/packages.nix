{pkgs, ...}: {
  home.packages = with pkgs; [
    curl
    eza
    fd
    jq
    ripgrep
  ];
}
