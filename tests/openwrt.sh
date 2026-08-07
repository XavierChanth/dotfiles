#!/usr/bin/env bash
# Negated probes below are assertions; SC2251 is intentional under errexit.
# shellcheck disable=SC2251
set -euo pipefail
root=${TEST_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}; tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
render=${CHARON_RENDER:-$(nix build --no-link --print-out-paths --no-write-lock-file "$root#openwrt-charon-uci")}
app=${CHARON_APP:-$(nix build --no-link --print-out-paths --no-write-lock-file "$root#openwrt-apply-charon")/bin/openwrt-apply-charon}
[[ $(grep -c '^set dhcp.dotfiles_lab_.*=hostrecord' "$render") == 4 ]]
grep -q 'dotfiles_lab_metadata=dotfiles' "$render"; ! grep -qi eris "$render"
# OpenWrt must not accidentally enter any system/home output set.
if [[ ${SKIP_FLAKE_EVAL:-0} == 0 ]]; then
  ! nix eval --json "$root#nixosConfigurations" --apply builtins.attrNames | grep -q 'charon'
  ! nix eval --json "$root#darwinConfigurations" --apply builtins.attrNames | grep -q 'charon'
  ! nix eval --json "$root#homeConfigurations" --apply builtins.attrNames | grep -q 'charon'
fi
# BusyBox nslookup answer parser accepts both layouts, but only an exact answer field.
dns_answer_is() { awk -v expected="$1" '$1 ~ /^Address(:|$)/ { for (i = 2; i <= NF; i++) if ($i == expected) found = 1 } END { exit !found }'; }
printf 'Server: 127.0.0.1\nAddress:\t192.168.8.1\n' | dns_answer_is 192.168.8.1
printf 'Name: charon.lab\nAddress 1: 192.168.8.1 charon.lab\n' | dns_answer_is 192.168.8.1
! printf 'Address:\t192.168.8.10\n' | dns_answer_is 192.168.8.1
! printf 'Server: 192.168.8.1\nAddressable 1: 192.168.8.1\n' | dns_answer_is 192.168.8.1
cat >"$tmp/ssh" <<'EOF'
#!/usr/bin/env bash
set -eu
# A real ssh may consume stdin unless -n is supplied. This faithfully does so when omitted.
has_n=0; for a in "$@"; do [[ $a != -n ]] || has_n=1; done
[[ $has_n == 1 ]] || cat >/dev/null
cmd=${*: -1}; echo "$cmd" >>"$LOG"
count() { f=$STATE/$1; n=0; [[ ! -f $f ]] || read -r n <"$f"; n=$((n+1)); echo "$n" >"$f"; echo "$n"; }
case $cmd in
 *'network.lan.ipaddr'*) exit 0;;
 'uci changes dhcp') [[ ${CASE:-} != pending ]] || { echo pending; exit 0; }; n=$(count changes); [[ $n == 1 ]] || echo staged-change;;
 *"mkdir '/tmp/dotfiles-openwrt-charon.lock'"*) [[ ${CASE:-} != lock ]] || exit 1;;
 *'seen='*)
   n=$(count verify)
   [[ ${CASE:-} != converged || $n -gt 1 ]] || exit 0
   [[ ${CASE:-} != partial || $n -ne 2 ]] || exit 1
   [[ ${CASE:-} != listbad || $n -ne 3 ]] || exit 1
   [[ $n -gt 1 ]] || exit 1;;
 *'sysupgrade -b'*) [[ ${CASE:-} != backup ]] || exit 1;;
 *'uci batch <'*) [[ ${CASE:-} != batchrc ]] || { echo 'uci: parse error' >&2; exit 1; };;
 'uci commit dhcp') [[ ${CASE:-} != commit ]] || exit 1;;
 *'/etc/init.d/dnsmasq reload && /etc/init.d/odhcpd reload'*) [[ ${CASE:-} != reload ]] || exit 1;;
 *nslookup*)
   name=${cmd#*nslookup }; name=${name%% *}; name=${name//\'/}
   echo "$name" >>"$STATE/names"
   n=$(count dns)
   [[ ${CASE:-} != dnsfail ]] || exit 1
   [[ ${CASE:-} != retry || $n -ne 1 ]] || exit 1;;
esac
EOF
cat >"$tmp/scp" <<'EOF'
#!/usr/bin/env bash
set -eu
echo "$*" >>"$LOG"; [[ " $* " == *' -O '* ]]; d=${*: -1}; [[ $d == *:* ]] || printf backup >"$d"
EOF
chmod +x "$tmp/ssh" "$tmp/scp"; export LOG=$tmp/log STATE=$tmp/state
common=(CHARON_HERMETIC_TEST=1 CHARON_RENDER="$render" CHARON_SSH_BIN="$tmp/ssh" CHARON_SCP_BIN="$tmp/scp" CHARON_BACKUP_DIR="$tmp/backups" CHARON_TTY_OUTPUT=/dev/null)
reset() { rm -rf "$STATE" "$tmp/backups"; mkdir -p "$STATE"; : >"$LOG"; }
run_fail() { reset; printf 'apply charon\n' >"$tmp/tty"; ! env "${common[@]}" CASE="$1" CHARON_TTY_PATH="$tmp/tty" "$app" --apply >"$tmp/out" 2>&1; }
# Argument and dry-run paths prove both injected command seams remain untouched.
reset; ! env "${common[@]}" "$app" --bogus >/dev/null 2>&1; "$app" --dry-run >/dev/null
[[ ! -s $LOG ]]; [[ ! -e $STATE/verify ]]
# Genuine convergence is determined by the same verifier and occurs before backup/stage.
reset; env "${common[@]}" CASE=converged CHARON_TTY_PATH=/nonexistent "$app" --apply >"$tmp/out"
grep -q 'Already converged' "$tmp/out"; ! grep -q sysupgrade "$LOG"; ! grep -q 'uci batch' "$LOG"
run_fail pending; ! grep -q sysupgrade "$LOG"
run_fail lock; ! grep -q sysupgrade "$LOG"
run_fail backup; grep -q sysupgrade "$LOG"; ! grep -q 'uci batch' "$LOG"
run_fail partial; grep -q 'staged UCI verification failed' "$tmp/out"; grep -q 'uci revert dhcp' "$LOG"; ! grep -q 'uci commit' "$LOG"
run_fail batchrc; grep -q 'parse error' "$tmp/out"; grep -q 'uci revert dhcp' "$LOG"
# Explicit refusal and TTY EOF both revert staged state.
reset; printf 'no\n' >"$tmp/tty"; ! env "${common[@]}" CHARON_TTY_PATH="$tmp/tty" "$app" --apply >/dev/null 2>&1; grep -q 'uci revert' "$LOG"
reset; : >"$tmp/tty"; ! env "${common[@]}" CHARON_TTY_PATH="$tmp/tty" "$app" --apply >/dev/null 2>&1; grep -q 'uci revert' "$LOG"
run_fail commit; grep -q 'failed or completion is ambiguous' "$tmp/out"; grep -q 'cp.*/etc/config/dhcp' "$LOG"
run_fail reload; grep -q "cp '/root/dotfiles-openwrt/backups/dhcp" "$LOG"
run_fail dnsfail; [[ $(wc -l <"$STATE/names") == 5 ]]; grep -q 'cp.*/etc/config/dhcp' "$LOG"
run_fail listbad; grep -q 'post-commit managed UCI/list validation failed' "$tmp/out"; grep -q 'cp.*/etc/config/dhcp' "$LOG"
# First lookup retries, then all four names validate. stdin-consuming mock proves -n preserves loop input.
reset; printf 'apply charon\n' >"$tmp/tty"; env "${common[@]}" CASE=retry CHARON_TTY_PATH="$tmp/tty" "$app" --apply >/dev/null
[[ $(wc -l <"$STATE/names") == 5 ]]; [[ $(sort -u "$STATE/names" | wc -l) == 4 ]]
grep -q charon.lab "$STATE/names"; grep -q zeus.lab "$STATE/names"
bash -n "$root/scripts/openwrt-apply-charon"; shellcheck "$root/scripts/openwrt-apply-charon" "$root/tests/openwrt.sh"
echo 'OpenWrt hermetic tests passed'
