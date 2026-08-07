#!/usr/bin/env bash
set -euo pipefail
: "${CHARON_RENDER:?}"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
export UCI_CONFIG_DIR=$tmp/config UCI_SAVEDIR=$tmp/save
mkdir -p "$UCI_CONFIG_DIR" "$UCI_SAVEDIR"
uci() { command uci -c "$UCI_CONFIG_DIR" -p "$UCI_SAVEDIR" "$@"; }
cat >"$UCI_CONFIG_DIR/dhcp" <<'EOF'
config dnsmasq 'main'
	list server '/unrelated.example/'
config dhcp 'lan'
	list dhcp_option '6,192.0.2.53'
config hostrecord 'keep'
	option name 'keep.example'
	option ip '192.0.2.9'
EOF
value() { sed -n "s/^set $1='\([^']*\)'$/\1/p" "$CHARON_RENDER"; }
owner=$(value dhcp.dotfiles_lab_metadata.dotfiles_owner)
server=$(value dhcp.dotfiles_lab_metadata.server); search=$(value dhcp.dotfiles_lab_metadata.search)
stage() {
  old_server=$(uci -q get dhcp.dotfiles_lab_metadata.server || :)
  old_search=$(uci -q get dhcp.dotfiles_lab_metadata.search || :)
  [[ -z $old_server ]] || uci -q del_list dhcp.@dnsmasq[0].server="$old_server"
  [[ -z $old_search ]] || uci -q del_list dhcp.lan.dhcp_option="$old_search"
  uci -q del_list dhcp.@dnsmasq[0].server="$server" || :
  uci -q del_list dhcp.lan.dhcp_option="$search" || :
  while read -r s; do [[ $(uci -q get "dhcp.$s.dotfiles_owner") != "$owner" ]] || uci delete "dhcp.$s"; done < <(uci show dhcp | sed -n 's/^dhcp\.\(dotfiles_lab_[A-Za-z0-9_]*\)=hostrecord$/\1/p')
  uci -q delete dhcp.dotfiles_lab_metadata || :
  uci batch <"$CHARON_RENDER"
}
verify() {
  [[ $(uci -q get dhcp.dotfiles_lab_metadata.dotfiles_owner) == "$owner" ]] || return 1
  [[ $(uci -q get dhcp.@dnsmasq[0].server | tr ' ' '\n' | grep -Fxc "$server") == 1 ]] || return 1
  [[ $(uci -q get dhcp.lan.dhcp_option | tr ' ' '\n' | grep -Fxc "$search") == 1 ]] || return 1
  while read -r s name; do
    [[ $(uci -q get "dhcp.$s.name") == "$name" ]] || return 1
    [[ $(uci -q get "dhcp.$s.ip") == "$(value "dhcp.$s.ip")" ]] || return 1
    [[ $(uci -q get "dhcp.$s.dotfiles_owner") == "$owner" ]] || return 1
  done < <(sed -n "s/^set dhcp\.\(dotfiles_lab_[^.]*\)\.name='\([^']*\)'$/\1 \2/p" "$CHARON_RENDER")
}
# Fresh apply and repeated convergence.
stage; verify; uci commit dhcp; stage; verify
# Desired duplicates without metadata collapse to one.
uci -q delete dhcp.dotfiles_lab_metadata || :
uci add_list dhcp.@dnsmasq[0].server="$server"; uci add_list dhcp.@dnsmasq[0].server="$server"
uci add_list dhcp.lan.dhcp_option="$search"; uci add_list dhcp.lan.dhcp_option="$search"
stage; verify
# Stale metadata cleans old values; unrelated sections and lists survive.
uci set dhcp.dotfiles_lab_metadata.server='/old.example/'
uci set dhcp.dotfiles_lab_metadata.search='option:domain-search,old.example'
uci add_list dhcp.@dnsmasq[0].server='/old.example/'
uci add_list dhcp.lan.dhcp_option='option:domain-search,old.example'
uci set dhcp.dotfiles_lab_rogue=hostrecord; uci set dhcp.dotfiles_lab_rogue.dotfiles_owner="$owner"
stage; verify
if uci -q get dhcp.@dnsmasq[0].server | grep -q old.example; then exit 1; fi
if uci -q get dhcp.lan.dhcp_option | grep -q old.example; then exit 1; fi
if uci -q get dhcp.dotfiles_lab_rogue; then exit 1; fi
[[ $(uci get dhcp.keep.name) == keep.example ]]
uci get dhcp.@dnsmasq[0].server | grep -q /unrelated.example/
uci get dhcp.lan.dhcp_option | grep -q '6,192.0.2.53'
# libuci batch can return success after partial input; the exact verifier rejects it,
# and the application then reverts all staged dhcp state.
uci revert dhcp
uci delete dhcp.dotfiles_lab_metadata
for s in charon hades poseidon zeus; do uci delete "dhcp.dotfiles_lab_$s"; done
head -n 10 "$CHARON_RENDER" >"$tmp/bad"
uci batch <"$tmp/bad"
if verify; then echo 'verifier accepted truncated batch' >&2; exit 1; fi
uci revert dhcp
verify
# Exact verifier must reject an incorrect IP.
uci set dhcp.dotfiles_lab_charon.ip=192.0.2.250
if verify; then echo 'verifier accepted incorrect IP' >&2; exit 1; fi
echo 'OpenWrt libuci semantic tests passed'
